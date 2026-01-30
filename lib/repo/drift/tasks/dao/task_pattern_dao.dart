import 'package:drift/drift.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_pattern.dart';

part 'task_pattern_dao.g.dart';

@DriftAccessor(tables: [TaskPatterns])
class TaskPatternDao extends DatabaseAccessor<LocalDB>
    with _$TaskPatternDaoMixin {
  TaskPatternDao(super.db);

  Future<TaskPattern?> getPatternById(String patternId) async {
    final row = await (select(
      taskPatterns,
    )..where((tbl) => tbl.id.equals(patternId))).getSingleOrNull();
    if (row == null) return null;
    return TaskPattern.fromEntry(row);
  }

  Future<void> markPatternDirty(String patternId, int rev) async {
    await (update(taskPatterns)..where((tbl) => tbl.id.equals(patternId)))
        .write(TaskPatternsCompanion(rev: Value(rev)));
  }

  Future<void> upsertPattern(TaskPattern pattern) async {
    await into(taskPatterns).insertOnConflictUpdate(pattern.toCompanion());
  }

  Future<List<TaskPattern>> getPatterns() => select(taskPatterns).get().then(
    (rows) => rows.map((row) => TaskPattern.fromEntry(row)).toList(),
  );

  Stream<List<TaskPattern>> watchChangedPatterns() => select(taskPatterns)
      .watch()
      .map((rows) => rows.map((row) => TaskPattern.fromEntry(row)).toList());

  Future<void> clearAll() async {
    await delete(taskPatterns).go();
  }
}
