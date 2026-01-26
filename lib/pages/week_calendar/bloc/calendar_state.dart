import 'package:timecraft/model/task_instance.dart';

class CalendarState {
  final DateTime fromUtc;
  final DateTime toUtc; // TODO to będzie getter w zależności od tydzień/miesiąc
  final List<TaskInstance> tasks;
  final bool loading;
  final String? error;

  const CalendarState({
    required this.fromUtc,
    required this.toUtc,
    required this.tasks,
    this.loading = false,
    this.error,
  });

  factory CalendarState.initial(DateTime fromUtc, DateTime toUtc) {
    return CalendarState(
      fromUtc: fromUtc,
      toUtc: toUtc,
      tasks: const [],
      loading: false,
      error: null,
    );
  }

  CalendarState copyWith({
    DateTime? fromUtc,
    DateTime? toUtc,
    List<TaskInstance>? tasks,
    bool? loading,
    String? error,
  }) {
    return CalendarState(
      fromUtc: fromUtc ?? this.fromUtc,
      toUtc: toUtc ?? this.toUtc,
      tasks: tasks ?? this.tasks,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
