import 'dart:math';

import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/service/repo/i_repo.dart';

class MockRepo implements IRepo {
  List<TaskInstance> get _tasks => _tasksMap.values.toList();
  Map<int, TaskInstance> _tasksMap = {};
  int currentId = 0;
  MockRepo() {
    int day = Random().nextInt(2);
    _tasksMap = {
      1: TaskInstance(
        id: 1,
        title: 'Zadanie 1',
        description: 'Opis zadania 1',
        startTime: DateTime.now().add(Duration(minutes: Random().nextInt(60))),
        endTime: DateTime.now().add(
          Duration(hours: 1, minutes: Random().nextInt(60)),
        ),
      ),
      2: TaskInstance(
        id: 2,
        title: 'Zadanie 2',
        description: 'Opis zadania 2',
        startTime: DateTime.now().add(
          Duration(days: day, minutes: Random().nextInt(60)),
        ),
        endTime: DateTime.now().add(
          Duration(days: day, hours: 1, minutes: Random().nextInt(60)),
        ),
      ),
    };
    currentId = 3;
  }
  @override
  Future<List<TaskInstance>> fetchTasks() async {
    // Zwraca przykładowe dane z opóźnieniem symulującym zapytanie sieciowe
    await Future.delayed(const Duration(seconds: 1));
    return _tasks;
  }

  @override
  Future<int> addTask(TaskInstance task) async {
    // Zwraca przykładowe dane z opóźnieniem symulującym zapytanie sieciowe
    await Future.delayed(const Duration(seconds: 1));
    _tasksMap[currentId] = task.copyWith(id: currentId);
    currentId++;
    return currentId - 1;
  }

  @override
  Future<void> updateTask(TaskInstance task) async {
    // Zwraca przykładowe dane z opóźnieniem symulującym zapytanie sieciowe
    await Future.delayed(const Duration(seconds: 1));
    _tasksMap[task.id] = task;
    // for (final t in _tasksMap.values) {
    //   print('${t.id} ${t.title} ${t.startTime} ${t.endTime}');
    // }
    return;
  }
}
