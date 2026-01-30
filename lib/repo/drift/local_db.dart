import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timecraft/repo/drift/tasks/dao/materialization_state_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/outbox_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_instance_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_override_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_pattern_dao.dart';
import 'package:timecraft/repo/drift/tasks/tables/materialization_state.dart';
import 'package:timecraft/repo/drift/tasks/tables/outbox.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_pattern.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_override.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_instance.dart';

part 'local_db.g.dart';

@DriftDatabase(
  tables: [
    TaskInstances,
    TaskPatterns,
    TaskOverrides,
    MaterializationStates,
    Outbox,
  ],
  daos: [
    TaskInstanceDao,
    TaskPatternDao,
    TaskOverrideDao,
    MaterializationStateDao,
    OutboxDao,
  ],
)
class LocalDB extends _$LocalDB {
  LocalDB() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
    },
  );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.dart.js'),
      ),
    );
  }

  Future<void> deleteDb() async => deleteDriftDatabaseFile('local_database');

  Future<void> clearAllTables() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }

  Future<void> deleteDriftDatabaseFile(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(join(dir.path, '$name.sqlite'));
    if (await file.exists()) {
      await file.delete();
    }
  }
}
