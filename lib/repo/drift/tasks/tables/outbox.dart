import 'package:drift/drift.dart';

@DataClassName('OutboxEntry')
class Outbox extends Table {
  TextColumn get uid => text()();

  TextColumn get entityType => text()();
  TextColumn get entityKey => text()();

  IntColumn get rev => integer()();
  TextColumn get payloadJson => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get sent => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {entityKey};
}
