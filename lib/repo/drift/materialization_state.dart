import 'package:drift/drift.dart';
import 'package:timecraft/repo/drift/local_db.dart';

class MaterializationState {
  final String taskId;
  final DateTime windowFrom;
  final DateTime windowTo;
  final int lastRev;
  MaterializationState({
    required this.taskId,
    required this.windowFrom,
    required this.windowTo,
    required this.lastRev,
  });

  MaterializationState.fromEntry(MaterializationStateEntry entry)
    : taskId = entry.taskId,
      windowFrom = entry.windowFrom,
      windowTo = entry.windowTo,
      lastRev = entry.lastRev;

  MaterializationStatesCompanion toCompanion() {
    return MaterializationStatesCompanion(
      taskId: Value(taskId),
      windowFrom: Value(windowFrom),
      windowTo: Value(windowTo),
      lastRev: Value(lastRev),
    );
  }
}
