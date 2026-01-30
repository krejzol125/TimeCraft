import 'package:drift/drift.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_instance.dart';

part 'task_instance_dao.g.dart';

@DriftAccessor(tables: [TaskInstances])
class TaskInstanceDao extends DatabaseAccessor<LocalDB>
    with _$TaskInstanceDaoMixin {
  TaskInstanceDao(super.db);

  Future<void> insertAll(List<TaskInstance> instances) async {
    for (final instance in instances) {
      await into(taskInstances).insert(instance.toCompanion());
    }
  }

  Future<void> replaceInstancesForPattern(
    String patternId,
    List<TaskInstance> rows,
  ) async {
    await transaction(() async {
      await (delete(
        taskInstances,
      )..where((tbl) => tbl.taskId.equals(patternId))).go();
      for (final row in rows) {
        await into(taskInstances).insert(row.toCompanion());
      }
    });
  }

  Stream<List<TaskInstance>> watchTasksInRange(DateTime from, DateTime to) {
    return (select(taskInstances)..where(
          (t) =>
              t.startTime.isBiggerOrEqualValue(from) &
              t.startTime.isSmallerThanValue(to) &
              t.deleted.equals(false),
        ))
        .watch()
        .map((rows) => rows.map((row) => TaskInstance.fromEntry(row)).toList());
  }

  Stream<List<TaskInstance>> watchUnscheduledTasks() {
    return (select(taskInstances)
          ..where((t) => t.startTime.isNull() & t.deleted.equals(false)))
        .watch()
        .map((rows) => rows.map((row) => TaskInstance.fromEntry(row)).toList());
  }

  Future<void> clearAll() async {
    await delete(taskInstances).go();
  }
}
