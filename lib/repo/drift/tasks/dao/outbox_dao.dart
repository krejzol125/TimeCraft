import 'package:drift/drift.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/tables/outbox.dart';

part 'outbox_dao.g.dart';

@DriftAccessor(tables: [Outbox])
class OutboxDao extends DatabaseAccessor<LocalDB> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  Stream<int> watchPendingCount(String uid) {
    final q = selectOnly(db.outbox)
      ..addColumns([db.outbox.entityKey.count()])
      ..where(db.outbox.uid.equals(uid) & db.outbox.sent.equals(false));
    return q.watch().map(
      (row) => row.first.read(db.outbox.entityKey.count()) ?? 0,
    );
  }

  Future<void> enqueue({
    required String uid,
    required String entityType,
    required String entityKey,
    required int rev,
    required String payloadJson,
  }) async {
    await into(outbox).insertOnConflictUpdate(
      OutboxCompanion.insert(
        uid: uid,
        entityType: entityType,
        entityKey: entityKey,
        rev: rev,
        payloadJson: payloadJson,
        sent: Value(false),
      ),
    );
  }

  Future<List<OutboxEntry>> nextBatch(String uid, {int limit = 50}) {
    return (select(outbox)
          ..where((t) => t.uid.equals(uid) & t.sent.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<void> markSent(String entityKey) async {
    await (update(outbox)..where((t) => t.entityKey.equals(entityKey))).write(
      const OutboxCompanion(sent: Value(true)),
    );
  }

  // Future<void> markFailed(String id, String err) async {
  //   await (update(outbox)..where((t) => t.id.equals(id))).write(
  //     OutboxCompanion(
  //       attempts:
  //           const Value.absent(), // jeśli chcesz inkrement: zrób custom update
  //       lastError: Value(err),
  //     ),
  //   );
  // }

  Future<void> clearSent(String uid) async {
    await (db.delete(
      db.outbox,
    )..where((t) => t.uid.equals(uid) & t.sent.equals(true))).go();
  }
}
