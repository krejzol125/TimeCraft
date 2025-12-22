import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/service/bloc/app_state.dart';
import 'package:timecraft/service/repo/repo_service.dart';

class AppCubit extends Cubit<AppState> {
  //List<TaskInstance> tasks = [];
  RepoService repo;
  AppCubit(this.repo) : super(AppInitial()) {
    repo.fetchTasks().then((value) {
      for (var task in value) print(task.title);
      emit(AppWeekLoaded(value));
      print(state.tasks.length);
    });
  }

  void addTask(TaskInstance task) async {
    //if (state is AppWeekLoading) return;
    emit(AppState.weekLoading());
    await repo.addTask(task);
    final tasks = await repo.fetchTasks();
    emit(AppState.weekLoaded(tasks));
  }

  void updateTask(TaskInstance task) async {
    //if (state is AppWeekLoading) return;
    emit(AppState.weekLoading());
    await repo.updateTask(task);
    final tasks = await repo.fetchTasks();
    emit(AppState.weekLoaded(tasks));
  }
}
