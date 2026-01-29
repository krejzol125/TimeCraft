import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/components/scope_dialog.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_state.dart';
import 'package:timecraft/repo/task_repo.dart';

class CalendarCubit extends Cubit<CalendarState> {
  TaskRepo repo;
  StreamSubscription<List<TaskInstance>>? _sub;

  CalendarCubit({required this.repo, required DateTime initialFromUtc})
    : super(CalendarState.initial(initialFromUtc)) {
    setRange(initialFromUtc);
  }

  void setViewMode(CalendarViewMode mode) {
    emit(state.copyWith(viewMode: mode, fromUtc: _monthStart(state.fromUtc)));
    setRange(state.fromUtc);
  }

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedUtc: date, fromUtc: _monthStart(date)));
    setRange(state.fromUtc);
  }

  DateTime _monthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  Future<void> setRange(DateTime fromUtc) async {
    emit(state.copyWith(fromUtc: fromUtc, loading: true, error: null));
    await _sub?.cancel();
    _sub = repo
        .watchTasksInWindow(
          fromUtc.subtract(Duration(days: 31)),
          state.toUtc.add(Duration(days: 31)),
        )
        .listen(
          (tasks) =>
              emit(state.copyWith(tasks: tasks, loading: false, error: null)),
          onError: (err, _) =>
              emit(state.copyWith(loading: false, error: err.toString())),
        );
  }

  Future<void> onTaskDrop(
    TaskInstance inst,
    DateTime? oldStartUtc,
    DateTime newStartUtc,
    Duration newDuration,
    BuildContext context,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    if (inst.isRepeating == false || oldStartUtc == null) {
      await repo.schedulePattern(inst.taskId, newStartUtc, newDuration);
      return;
    }
    final offset = newStartUtc.difference(oldStartUtc);

    final scope = await showMoveScopeDialog(context);
    if (scope == null) {
      emit(state.copyWith(loading: false));
      return;
    }

    switch (scope) {
      case RecurrenceMoveScope.singleOccurrence:
        await repo.rescheduleOneInstancePattern(
          inst.taskId,
          inst.rid!,
          newStartUtc,
          newDuration,
        );
        break;

      case RecurrenceMoveScope.thisAndFuture:
        await repo.rescheduleThisAndFuturePattern(
          inst.taskId,
          inst.rid!,
          offset,
          newDuration,
        );
        break;

      case RecurrenceMoveScope.entireSeries:
        await repo.rescheduleAllPattern(
          inst.taskId,
          offset,
          newDuration,
          fromWeekday: inst.startTime?.weekday,
        );
        break;
    }
    return;
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
