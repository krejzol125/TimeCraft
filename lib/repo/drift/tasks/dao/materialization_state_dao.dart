import 'package:drift/drift.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/materialization_state.dart';
import 'package:timecraft/repo/drift/tasks/tables/materialization_state.dart';

part 'materialization_state_dao.g.dart';

@DriftAccessor(tables: [MaterializationStates])
class MaterializationStateDao extends DatabaseAccessor<LocalDB>
    with _$MaterializationStateDaoMixin {
  MaterializationStateDao(super.db);

  Future<MaterializationState?> getState(String key) async {
    final row = await (select(
      materializationStates,
    )..where((tbl) => tbl.taskId.equals(key))).getSingleOrNull();
    if (row == null) return null;
    return MaterializationState.fromEntry(row);
  }

  Future<void> upsertState(MaterializationState state) async {
    await into(
      materializationStates,
    ).insertOnConflictUpdate(state.toCompanion());
  }
}
