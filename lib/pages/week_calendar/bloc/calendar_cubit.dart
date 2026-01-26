import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/week_calendar/bloc/calendar_state.dart';
import 'package:timecraft/repo/repo_service.dart';
import 'package:timecraft/repo/task_repo.dart';

class CalendarCubit extends Cubit<CalendarState> {
  //List<TaskInstance> tasks = [];
  TaskRepo repo;
  StreamSubscription<List<TaskInstance>>? _sub;

  CalendarCubit({
    required this.repo,
    required DateTime initialFromUtc,
    required DateTime initialToUtc,
  }) : super(CalendarState.initial(initialFromUtc, initialToUtc)) {
    setRange(initialFromUtc, initialToUtc);
  }

  Future<void> setRange(DateTime fromUtc, DateTime toUtc) async {
    emit(
      state.copyWith(
        fromUtc: fromUtc,
        toUtc: toUtc,
        loading: true,
        error: null,
      ),
    );
    await _sub?.cancel();
    _sub = repo
        .watchTasksInWindow(fromUtc, toUtc)
        .listen(
          (tasks) =>
              emit(state.copyWith(tasks: tasks, loading: false, error: null)),
          onError: (err, _) =>
              emit(state.copyWith(loading: false, error: err.toString())),
        );
  }

  Future<void> onTaskDropped({
    required String id,
    required DateTime startUtc,
    required Duration duration,
  }) async {
    try {
      await repo.scheduleTask(id, startUtc, duration);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
