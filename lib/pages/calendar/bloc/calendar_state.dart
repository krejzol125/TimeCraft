import 'package:timecraft/model/task_instance.dart';

enum CalendarViewMode { day, week }

class CalendarState {
  final DateTime fromUtc;
  DateTime get toUtc => fromUtc.add(Duration(days: 31));
  final DateTime selectedUtc;
  final List<TaskInstance> tasks;
  final bool loading;
  final CalendarViewMode viewMode;
  final String? error;

  const CalendarState({
    required this.fromUtc,
    required this.selectedUtc,
    required this.tasks,
    required this.viewMode,
    this.loading = false,
    this.error,
  });

  factory CalendarState.initial(DateTime fromUtc) {
    return CalendarState(
      fromUtc: fromUtc,
      selectedUtc: fromUtc,
      tasks: const [],
      viewMode: CalendarViewMode.week,
      loading: false,
      error: null,
    );
  }

  CalendarState copyWith({
    DateTime? fromUtc,
    DateTime? selectedUtc,
    List<TaskInstance>? tasks,
    CalendarViewMode? viewMode,
    bool? loading,
    String? error,
  }) {
    return CalendarState(
      fromUtc: fromUtc ?? this.fromUtc,
      selectedUtc: selectedUtc ?? this.selectedUtc,
      tasks: tasks ?? this.tasks,
      viewMode: viewMode ?? this.viewMode,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
