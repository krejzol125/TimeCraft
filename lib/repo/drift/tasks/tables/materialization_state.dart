import 'package:drift/drift.dart';

@DataClassName('MaterializationStateEntry')
class MaterializationStates extends Table {
  TextColumn get taskId => text()();
  IntColumn get lastRev => integer()();
  DateTimeColumn get windowFrom => dateTime()();
  DateTimeColumn get windowTo => dateTime()();

  @override
  Set<Column> get primaryKey => {taskId};
}
