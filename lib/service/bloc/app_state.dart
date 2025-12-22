import 'package:timecraft/model/task_instance.dart';

sealed class AppState {
  final List<TaskInstance> tasks;
  const AppState(this.tasks);
  const factory AppState.initial() = AppInitial;
  const factory AppState.weekLoading() = AppWeekLoading;
  factory AppState.weekLoaded(List<TaskInstance> tasks) => AppWeekLoaded(tasks);
  // const factory AppState.monthLoaded() = AppMonthLoaded;
  // const factory AppState.monthLoading() = AppMonthLoading;
}

class AppInitial extends AppState {
  const AppInitial() : super(const []);
}

class AppWeekLoading extends AppState {
  const AppWeekLoading() : super(const []);
}

class AppWeekLoaded extends AppState {
  const AppWeekLoaded(super.tasks);
}

// class AppMonthLoaded extends AppState {
//   const AppMonthLoaded();
// }

// class AppMonthLoading extends AppState {
//   const AppMonthLoading();
// }
