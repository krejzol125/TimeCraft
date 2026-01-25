import 'dart:async';

import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/materialization_state.dart';
import 'package:timecraft/repo/drift/tasks/dao/materialization_state_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_instance_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_override_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_pattern_dao.dart';

class MaterializationWorker {
  DateTime _materializedTo;
  DateTime get materializedTo => _materializedTo;
  DateTime _materializedFrom;
  DateTime get materializedFrom => _materializedFrom;

  Duration get bufforDurationBefore => Duration(days: 30);
  Duration get bufforDurationAfter => Duration(days: 60);

  final TaskPatternDao _taskPatternDao;
  final TaskOverrideDao _taskOverrideDao;
  final TaskInstanceDao _taskInstanceDao;
  final MaterializationStateDao _materializationStateDao;
  //StreamSubscription? _patternSub;
  //StreamSubscription? _overrideSub;
  Timer? _debounceTimer;
  final Duration _debounceDuration = Duration(milliseconds: 300);
  final Set<String> _pending = {};
  bool _isProcessing = false;

  MaterializationWorker(LocalDB db)
    : _taskPatternDao = TaskPatternDao(db),
      _taskOverrideDao = TaskOverrideDao(db),
      _taskInstanceDao = TaskInstanceDao(db),
      _materializationStateDao = MaterializationStateDao(db),
      _materializedFrom = DateTime.now().subtract(Duration(days: 30)),
      _materializedTo = DateTime.now().add(Duration(days: 60)) {
    _taskPatternDao.watchChangedPatterns().listen((patterns) {
      for (final pattern in patterns) {
        _pending.add(pattern.id);
      }
      _debounceTimer?.cancel();
      _debounceTimer = Timer(_debounceDuration, () {
        _processPending();
      });
    });
    _taskOverrideDao.watchChangedOverrides().listen((overrides) {
      for (final override in overrides) {
        _pending.add(override.taskId);
      }
      _debounceTimer?.cancel();
      _debounceTimer = Timer(_debounceDuration, () {
        _processPending();
      });
    });
  }

  Future<void> enzureRange(DateTime from, DateTime to) async {
    bool shouldRematerialize = false;
    if (from.subtract(bufforDurationBefore).isBefore(_materializedFrom)) {
      _materializedFrom = from.subtract(bufforDurationBefore);
      shouldRematerialize = true;
    }
    if (to.add(bufforDurationAfter).isAfter(_materializedTo)) {
      _materializedTo = to.add(bufforDurationAfter);
      shouldRematerialize = true;
    }
    final patterns = await _taskPatternDao.getPatterns();
    if (shouldRematerialize) {
      for (final pattern in patterns) {
        _pending.add(pattern.id);
      }
      await _processPending();
    }
  }

  Future<void> _processPending() async {
    if (_isProcessing) {
      _debounceTimer = Timer(_debounceDuration, () {
        _processPending();
      });
      return;
    }
    _isProcessing = true;
    try {
      final toProcess = Set<String>.from(_pending);
      _pending.clear();
      for (final taskId in toProcess) {
        await _rematerializeTask(taskId);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _rematerializeTask(String taskId) async {
    TaskPattern? pattern = await _taskPatternDao.getPatternById(taskId);
    if (pattern == null || pattern.deleted) return;
    List<TaskOverride> overrides = await _taskOverrideDao.getOverridesForTask(
      taskId,
    );
    print(
      'Rematerializing task $taskId with rev ${pattern.rev} and ${overrides.length} overrides',
    );
    Map<String, TaskOverride> overrideMap = {
      for (var ovr in overrides) ovr.rid.toIso8601String(): ovr,
    };
    MaterializationState? state = await _materializationStateDao.getState(
      taskId,
    );
    int lastRev = state?.lastRev ?? -1;

    bool shouldRematerialize =
        pattern.rev > lastRev ||
        state?.windowFrom.isAfter(materializedFrom) == true ||
        state?.windowTo.isBefore(materializedTo) == true;
    if (!shouldRematerialize) {
      return;
    }

    final newState = MaterializationState(
      taskId: taskId,
      lastRev: pattern.rev,
      windowFrom: materializedFrom,
      windowTo: materializedTo,
    );
    await _materializationStateDao.upsertState(newState);

    if (pattern.rrule == null) {
      await _taskInstanceDao.replaceInstancesForPattern(taskId, [
        TaskInstance.fromPattern(
          pattern,
          pattern.startTime,
          taskOverride: overrides.isNotEmpty ? overrides.first : null,
        ),
      ]);
      return;
    }

    if (pattern.startTime!.isAfter(materializedTo)) {
      await _taskInstanceDao.replaceInstancesForPattern(taskId, []);
      return;
    }

    List<DateTime> materializedDates = pattern.rrule!.getAllInstances(
      start: pattern.startTime!.copyWith(isUtc: true), // TODO utc
      after: materializedFrom.isBefore(pattern.startTime!)
          ? pattern.startTime!.copyWith(isUtc: true)
          : materializedFrom.copyWith(isUtc: true),
      before: materializedTo.copyWith(isUtc: true),
      includeAfter: true,
      includeBefore: true,
    );
    List<TaskInstance> instances = materializedDates.map((dt) {
      TaskOverride? override =
          overrideMap[dt.copyWith(isUtc: false).toIso8601String()];
      if (override != null) {
        print(
          'Applying override ${override.rid} for pattern $taskId at ${dt.copyWith(isUtc: false)}',
        );
      }
      return TaskInstance.fromPattern(
        pattern,
        dt.copyWith(isUtc: false),
        taskOverride: override,
      );
    }).toList();
    await _taskInstanceDao.replaceInstancesForPattern(taskId, instances);
  }
}
