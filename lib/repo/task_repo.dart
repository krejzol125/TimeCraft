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

  Stream<List<TaskInstance>> watchTasksInWindow(DateTime from, DateTime to) {
    var stream = _taskInstanceDao.watchTasksInRange(from, to);
    _materializationWorker.enzureRange(from, to);
    return stream;
  }

  Stream<List<TaskInstance>> watchUnscheduledTasks() {
    return _taskInstanceDao.watchUnscheduledTasks();
  }

  Future<void> createPattern(TaskPattern tp) async {
    await _taskPatternDao.upsertPattern(
      tp.copyWith(rev: DateTime.now().millisecondsSinceEpoch),
    );
  }

  Future<void> overrideTask(TaskOverride to) async {
    await _taskOverrideDao.upsertOverride(to);
    _taskPatternDao.markPatternDirty(
      to.taskId,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> createOverride(TaskOverride to) async {
    await _taskOverrideDao.upsertOverride(to);
  }
}
