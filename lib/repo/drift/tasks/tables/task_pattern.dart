import 'package:drift/drift.dart';

@DataClassName('TaskPatternEntry')
class TaskPatterns extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();
  TextColumn get completion => text().withDefault(const Constant('0 false'))();
  TextColumn get description => text().nullable()();

  DateTimeColumn get startTime => dateTime().nullable()();
  IntColumn get duration => integer().nullable()();

  TextColumn get rrule => text().nullable()();
  TextColumn get rdates => text().nullable()();
  TextColumn get exdates => text().nullable()();

  TextColumn get tags => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(3))();
  TextColumn get reminders => text().nullable()();
  TextColumn get subTasks => text().nullable()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  IntColumn get rev => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
