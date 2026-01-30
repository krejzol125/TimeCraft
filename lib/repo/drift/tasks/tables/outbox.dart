import 'package:drift/drift.dart';

@DataClassName('OutboxEntry')
class Outbox extends Table {
  //IntColumn get id => integer().autoIncrement()();
  TextColumn get uid => text()();

  TextColumn get entityType => text()();
  TextColumn get entityKey => text()();
  //TextColumn get op => text()();

  IntColumn get rev => integer()();
  TextColumn get payloadJson => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // IntColumn get attempts => integer().withDefault(const Constant(0))();
  //TextColumn get lastError => text().nullable()();
  BoolColumn get sent => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {entityKey};
}
