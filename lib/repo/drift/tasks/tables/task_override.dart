import 'package:drift/drift.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_pattern.dart';

@DataClassName('TaskOverrideEntry')
class TaskOverrides extends Table {
  TextColumn get taskId => text().references(TaskPatterns, #id)();
  DateTimeColumn get rid => dateTime()();

  TextColumn get title => text().nullable()();
  TextColumn get completion => text().nullable()();
  TextColumn get description => text().nullable()();

  DateTimeColumn get startTime => dateTime().nullable()();
  IntColumn get duration => integer().nullable()();

  TextColumn get rrule => text().nullable()();

  TextColumn get tags => text().nullable()();
  IntColumn get priority => integer().nullable()();
  TextColumn get reminders => text().nullable()();
  TextColumn get subTasks => text().nullable()();

  IntColumn get rev => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {taskId, rid};
}
