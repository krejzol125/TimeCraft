import 'package:drift/drift.dart';
import 'package:timecraft/repo/drift/tasks/tables/task_pattern.dart';

@DataClassName('TaskInstanceEntry')
@TableIndex(name: "rid_index", columns: {#startTime})
class TaskInstances extends Table {
  TextColumn get taskId => text().references(TaskPatterns, #id)();
  DateTimeColumn get rid => dateTime().nullable()();

  TextColumn get title => text()();
  TextColumn get completion => text().withDefault(const Constant('0 false'))();
  TextColumn get description => text().nullable()();

  DateTimeColumn get startTime => dateTime().nullable()();
  IntColumn get duration => integer().nullable()();
  BoolColumn get isRepeating => boolean().withDefault(const Constant(false))();

  TextColumn get tags => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(3))();
  TextColumn get reminders => text().nullable()();
  TextColumn get subTasks => text().nullable()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {taskId, rid};
}
