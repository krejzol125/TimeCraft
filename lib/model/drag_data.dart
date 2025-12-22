import 'package:timecraft/model/task_instance.dart';

enum DragMode { move, resize }

class DragData {
  final TaskInstance task;
  final DragMode mode;
  DragData(this.task, this.mode);
}
