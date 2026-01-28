import 'package:rrule/rrule.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_instance_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_override_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_pattern_dao.dart';
import 'package:timecraft/repo/drift/tasks/materialization_worker.dart';

class TaskRepo {
  final TaskInstanceDao _taskInstanceDao;
  final TaskPatternDao _taskPatternDao;
  final TaskOverrideDao _taskOverrideDao;
  final MaterializationWorker _materializationWorker;

  TaskRepo(LocalDB db, this._materializationWorker)
    : _taskInstanceDao = TaskInstanceDao(db),
      _taskPatternDao = TaskPatternDao(db),
      _taskOverrideDao = TaskOverrideDao(db);

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

  Future<void> createPattern(TaskPattern tp) async {
    await _taskPatternDao.upsertPattern(
      tp.copyWith(rev: DateTime.now().millisecondsSinceEpoch),
    );
  }

  // Future<void> createOverride(TaskOverride to) async {
  //   await _taskOverrideDao.upsertOverride(to);
  // }

  // ! Update

  Future<void> overrideTask(TaskOverride to) async {
    await _taskOverrideDao.upsertOverride(to);
    _taskPatternDao.markPatternDirty(
      to.taskId,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> schedulePattern(
    String taskId,
    DateTime startTime,
    Duration duration,
  ) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    await _taskPatternDao.upsertPattern(
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
    int? fromWeekday,
  }) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    final startTime = pattern.startTime!.add(offset);
    if (pattern.rrule?.frequency == Frequency.weekly) {
      List<ByWeekDayEntry> days = pattern.rrule?.byWeekDays ?? [];
      if (fromWeekday != null) {
        days.removeWhere((element) => element.day == fromWeekday);
        days.add(ByWeekDayEntry(startTime.weekday));
      } else {
        days = [];
      }

      final rrule = pattern.rrule!.copyWith(
        byWeekDays: days,
        until: pattern.rrule?.until?.add(offset),
      );

      _taskPatternDao.upsertPattern(
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
    _taskPatternDao.upsertPattern(
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
    await _taskOverrideDao.upsertOverride(to);
    await _taskPatternDao.markPatternDirty(
      taskId,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> rescheduleThisAndFuturePattern(
    String taskId,
    DateTime splitRid,
    Duration offset,
    Duration duration,
  ) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null) return;
    await _taskPatternDao.upsertPattern(
      pattern.copyWith(
        rrule: pattern.rrule?.copyWith(
          until: pattern.rrule?.until != null
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
    await _taskPatternDao.upsertPattern(newPattern);
  }
}
