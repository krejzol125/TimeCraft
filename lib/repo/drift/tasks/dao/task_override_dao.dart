import 'package:drift/drift.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_override.dart';

part 'task_override_dao.g.dart';

@DriftAccessor(tables: [TaskOverrides])
class TaskOverrideDao extends DatabaseAccessor<LocalDB>
    with _$TaskOverrideDaoMixin {
  TaskOverrideDao(super.db);

  Future<List<TaskOverride>> getOverridesForTask(String taskId) async {
    return (select(
      taskOverrides,
    )..where((tbl) => tbl.taskId.equals(taskId))).get().then(
      (rows) => rows.map((row) => TaskOverride.fromEntry(row)).toList(),
    );
  }

  Future<TaskOverride?> getOverrideById(String taskId, DateTime rid) async {
    
    return (select(taskOverrides)
          ..where((tbl) => tbl.taskId.equals(taskId) & tbl.rid.equals(rid)))
        .getSingleOrNull()
        .then((row) => row != null ? TaskOverride.fromEntry(row) : null);
  }

  Future<void> upsertOverride(TaskOverride override) async {
    await into(taskOverrides).insertOnConflictUpdate(override.toCompanion());
  }

  Stream<List<TaskOverride>> watchChangedOverrides() => select(taskOverrides)
      .watch()
      .map((rows) => rows.map((row) => TaskOverride.fromEntry(row)).toList());
}
