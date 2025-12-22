import 'package:timecraft/model/task_instance.dart';

abstract class IRepo {
  Future<List<TaskInstance>> fetchTasks();
  Future<int> addTask(TaskInstance task);
  Future<void> updateTask(TaskInstance task);
}
