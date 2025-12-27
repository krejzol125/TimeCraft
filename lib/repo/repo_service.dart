import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/repo/i_repo.dart';
import 'package:timecraft/repo/mock_repo.dart';

class RepoService {
  final IRepo repo;
  RepoService(this.repo);
  RepoService.mock() : repo = MockRepo();

  Future<List<TaskInstance>> fetchTasks() {
    return repo.fetchTasks();
  }

  Future<int> addTask(TaskInstance task) {
    return repo.addTask(task);
  }

  Future<void> updateTask(TaskInstance task) {
    return repo.updateTask(task);
  }
}
