import 'package:rrule/rrule.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/dao/outbox_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_instance_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_override_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_pattern_dao.dart';
import 'package:timecraft/repo/drift/tasks/materialization_worker.dart';

class TaskRepo {
  final TaskInstanceDao _taskInstanceDao;
  final TaskPatternDao _taskPatternDao;
  final TaskOverrideDao _taskOverrideDao;
  final OutboxDao _outboxDao;
  final MaterializationWorker _materializationWorker;
  String? _uid;

  TaskRepo(LocalDB db, this._materializationWorker)
    : _taskInstanceDao = TaskInstanceDao(db),
      _taskPatternDao = TaskPatternDao(db),
      _taskOverrideDao = TaskOverrideDao(db),
      _outboxDao = OutboxDao(db);

  void setUser(String? uid) => _uid = uid;

  String overrideKey(String taskId, DateTime ridUtc) =>
      '${taskId}__${ridUtc.toUtc().toIso8601String()}';

  // ! Queries
  Future<TaskPattern?> getPatternById(String id) async {
    return _taskPatternDao.getPatternById(id);
  }

  // ! Streams

  Stream<List<TaskInstance>> watchTasksInWindow(DateTime from, DateTime to) {
    var stream = _taskInstanceDao.watchTasksInRange(from, to);
    _materializationWorker.enzureRange(from, to);
    return stream;
  }

  Stream<List<TaskInstance>> watchUnscheduledTasks() {
    return _taskInstanceDao.watchUnscheduledTasks();
  }

  // ! Create

  // Future<void> upsertPattern(TaskPattern tp) async {
  //   await _taskPatternDao.upsertPattern(
  //     tp.copyWith(rev: DateTime.now().millisecondsSinceEpoch),
  //   );
  // }

  Future<void> upsertPattern(TaskPattern tp) async {
    final now = DateTime.now().toUtc();
    final rev = now.millisecondsSinceEpoch;

    final updated = tp.copyWith(rev: rev, updatedAt: now);

    await _taskPatternDao.transaction(() async {
      await _taskPatternDao.upsertPattern(updated);

      if (_uid != null) {
        print('enqueuing pattern update for uid $_uid');
        await _outboxDao.enqueue(
          uid: _uid!,
          entityType: 'pattern',
          entityKey: updated.id,
          rev: updated.rev,
          payloadJson: updated.toJson(),
        );
      }
    });
  }

  // Future<void> createOverride(TaskOverride to) async {
  //   await _taskOverrideDao.upsertOverride(to);
  // }

  // ! Update

  Future<void> overrideTask(TaskOverride to) async {
    final now = DateTime.now().toUtc();
    final rev = now.millisecondsSinceEpoch;

    final existing = await _taskOverrideDao.getOverrideById(to.taskId, to.rid);
    if (existing != null) {
      to = existing.add(to);
    }

    final updated = to.copyWith(updatedAt: now, rev: rev);

    await _taskOverrideDao.transaction(() async {
      await _taskOverrideDao.upsertOverride(updated);

      await _taskPatternDao.markPatternDirty(to.taskId, rev);

      if (_uid != null) {
        await _outboxDao.enqueue(
          uid: _uid!,
          entityType: 'override',
          entityKey: overrideKey(updated.taskId, updated.rid),
          rev: rev,
          payloadJson: updated.toJson(),
        );
      }
    });
  }

  // Future<void> overrideTask(TaskOverride to) async {
  //   final existing = await _taskOverrideDao.getOverrideById(to.taskId, to.rid);
  //   if (existing != null) {
  //     to = existing.add(to);
  //   }
  //   await _upsertOverride(to);
  // }

  Future<void> splitPattern(
    String taskId,
    DateTime splitRid,
    TaskPattern newPattern,
  ) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    await _taskPatternDao.upsertPattern(
      pattern.copyWith(
        rrule: pattern.rrule?.copyWith(
          count: null,
          until: splitRid
              .subtract(const Duration(seconds: 1))
              .copyWith(isUtc: true),
        ),
        rev: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now(),
      ),
    );
    await _taskPatternDao.upsertPattern(
      newPattern.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        rev: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> schedulePattern(
    String taskId,
    DateTime startTime,
    Duration duration,
  ) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    await upsertPattern(
      pattern.copyWith(
        startTime: startTime,
        duration: duration,
        rev: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> rescheduleAllPattern(
    String taskId,
    Duration offset,
    Duration duration, {
    DateTime? rid,
    int? fromWeekday,
  }) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    final startTime = pattern.startTime!.add(offset);
    if (pattern.rrule?.frequency == Frequency.weekly) {
      Set<ByWeekDayEntry> days = pattern.rrule?.byWeekDays.toSet() ?? {};
      if (fromWeekday != null) {
        days.removeWhere((element) => element.day == fromWeekday);
        days.add(ByWeekDayEntry(startTime.weekday));
      } else {
        days = {};
      }

      final rrule = pattern.rrule!.copyWith(
        byWeekDays: days.toList(),
        until: pattern.rrule?.until?.add(offset),
      );
      print('new rule is $rrule');

      await upsertPattern(
        pattern.copyWith(
          startTime: startTime,
          duration: duration,
          rrule: rrule,
          rev: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now(),
        ),
      );
      return;
    }
    final overrides = await _taskOverrideDao.getOverridesForTask(taskId);
    for (var ovr in overrides) {
      TaskOverride newOvr = ovr.copyWith(rid: ovr.rid.add(offset));
      if (rid != null && ovr.rid.isAtSameMomentAs(rid)) {
        newOvr.startTime = null;
        newOvr.duration = null;
      }
      await overrideTask(newOvr);
    }
    await upsertPattern(
      pattern.copyWith(
        startTime: startTime,
        duration: duration,
        rrule: pattern.rrule!.copyWith(
          until: pattern.rrule?.until?.add(offset),
        ),
        rev: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<void> rescheduleOneInstancePattern(
    String taskId,
    DateTime rid,
    DateTime startTime,
    Duration duration,
  ) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    TaskOverride to = TaskOverride.fromPattern(
      pattern,
      rid,
      startTime: startTime,
      duration: duration,
    );
    await overrideTask(to);
  }

  Future<void> rescheduleThisAndFuturePattern(
    String taskId,
    DateTime splitRid,
    Duration offset,
    Duration duration,
  ) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    await upsertPattern(
      pattern.copyWith(
        rrule: pattern.rrule?.copyWith(
          until: pattern.rrule?.count == null
              ? splitRid
                    .subtract(const Duration(seconds: 1))
                    .copyWith(isUtc: true)
              : null,
        ),
        rev: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now(),
      ),
    );
    TaskPattern newPattern = pattern.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: splitRid.add(offset),
      duration: duration,
      rev: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now(),
    );
    await upsertPattern(newPattern);
  }
}
