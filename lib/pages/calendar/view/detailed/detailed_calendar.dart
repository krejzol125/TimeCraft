import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_cubit.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_state.dart';
import 'package:timecraft/pages/calendar/view/detailed/day_column.dart';
import 'package:timecraft/repo/task_repo.dart';

class DetailedCalendar extends StatefulWidget {
  const DetailedCalendar(
    this.tasks,
    this.calendarStartDate,
    this.repo,
    this.viewMode, {
    this.onScrollControllerReady,
    super.key,
  });

  final TaskRepo repo;
  final CalendarViewMode viewMode;
  final void Function(ScrollController controller)? onScrollControllerReady;

  static const double baseHalfHourHeight = 40.0;
  static const int halfHoursPerDay = 48;
  static const List<String> weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<TaskInstance> tasks;

  static const int snapMinutes = 1;
  static const int minDurationMinutes = 10;

  final DateTime calendarStartDate;

  @override
  State<DetailedCalendar> createState() => _DetailedCalendarState();
}

class _DetailedCalendarState extends State<DetailedCalendar> {
  _DetailedCalendarState();

  String _weekdayLabel(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.weekdayMonShort;
      case 1:
        return l10n.weekdayTueShort;
      case 2:
        return l10n.weekdayWedShort;
      case 3:
        return l10n.weekdayThuShort;
      case 4:
        return l10n.weekdayFriShort;
      case 5:
        return l10n.weekdaySatShort;
      case 6:
        return l10n.weekdaySunShort;
      default:
        return l10n.weekdayMonShort;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onScrollControllerReady?.call(_vScroll);
    });
  }

  final double dayWidth = 100.0;

  final ScrollController _vScroll = ScrollController();

  final Map<String, GlobalKey> dayKeys = {
    'Mon': GlobalKey(),
    'Tue': GlobalKey(),
    'Wed': GlobalKey(),
    'Thu': GlobalKey(),
    'Fri': GlobalKey(),
    'Sat': GlobalKey(),
    'Sun': GlobalKey(),
  };

  final scrollKey = GlobalKey();

  DateTime get calendarStartDate => widget.calendarStartDate;

  Map<String, DateTime> get weekStartDates {
    final weekStartDate = calendarStartDate.subtract(
      Duration(days: calendarStartDate.weekday - 1),
    );
    return {
      'Mon': weekStartDate,
      'Tue': weekStartDate.add(const Duration(days: 1)),
      'Wed': weekStartDate.add(const Duration(days: 2)),
      'Thu': weekStartDate.add(const Duration(days: 3)),
      'Fri': weekStartDate.add(const Duration(days: 4)),
      'Sat': weekStartDate.add(const Duration(days: 5)),
      'Sun': weekStartDate.add(const Duration(days: 6)),
    };
  }

  bool isSameDay(DateTime date1, DateTime date2) =>
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;

  Map<String, List<TaskInstance>> tasksByDay() {
    final map = <String, List<TaskInstance>>{
      for (final d in DetailedCalendar.weekdays) d: <TaskInstance>[],
    };

    for (final t in widget.tasks) {
      final st = t.startTime;
      if (st == null) continue;
      for (final d in DetailedCalendar.weekdays) {
        if (isSameDay(st, weekStartDates[d]!)) {
          map[d]!.add(t);
          break;
        }
      }
    }
    return map;
  }

  double _dateToHeight(DateTime startTime, DateTime endTime) {
    final minutes = endTime.difference(startTime).inMinutes;
    return minutes * _pixelsPerMinute;
  }

  DateTime _snapMinutes(DateTime dt) {
    final total = dt.hour * 60 + dt.minute;
    final snapped =
        (total / DetailedCalendar.snapMinutes).round() *
        DetailedCalendar.snapMinutes;
    final h = snapped ~/ 60;
    final m = snapped % 60;
    return DateTime(dt.year, dt.month, dt.day, h, m);
  }

  static const Duration _defaultDuration = Duration(minutes: 60);

  // ! Zoom

  double _zoom = 1.0;
  static const double _minZoom = 0.5;
  static const double _maxZoom = 3.0;
  double get _halfHourHeight => DetailedCalendar.baseHalfHourHeight * _zoom;
  double get _pixelsPerMinute => _halfHourHeight / 30.0;
  final GlobalKey _viewportKey = GlobalKey();

  double? _scaleStartZoom;

  void _applyZoom(double targetZoom, {required Offset focalGlobal}) {
    final rb = scrollKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null || !_vScroll.hasClients) {
      setState(() => _zoom = targetZoom.clamp(_minZoom, _maxZoom));
      return;
    }

    final newZoom = targetZoom.clamp(_minZoom, _maxZoom);
    if ((newZoom - _zoom).abs() < 0.0001) return;

    final localY = rb.globalToLocal(focalGlobal).dy;

    final oldPPM = DetailedCalendar.baseHalfHourHeight * _zoom / 30.0;
    final newPPM = DetailedCalendar.baseHalfHourHeight * newZoom / 30.0;

    final contentYBefore = _vScroll.offset + localY;
    final minutesAtFocal = contentYBefore / oldPPM;
    final contentYAfter = minutesAtFocal * newPPM;
    final wantedOffset = contentYAfter - localY;

    setState(() => _zoom = newZoom);

    final minScroll = _vScroll.position.minScrollExtent;
    final maxScroll = _vScroll.position.maxScrollExtent;
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (!_vScroll.hasClients) return;
      _vScroll.jumpTo(wantedOffset.clamp(minScroll, maxScroll));
    });
  }

  void _onScaleStart(ScaleStartDetails d) {
    _scaleStartZoom = _zoom;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final base = _scaleStartZoom ?? _zoom;
    final focal = d.focalPoint;
    _applyZoom(base * d.scale, focalGlobal: focal);
  }

  void _onScaleEnd(ScaleEndDetails d) {
    _scaleStartZoom = null;
  }

  int _lastZoomUpdateTs = 0;
  static const int _zoomUpdateIntervalUs = 16 * 1000;

  void _onPointerSignal(PointerSignalEvent e) {
    if (e is! PointerScrollEvent) return;

    //final pressed = RawKeyboard.instance.keysPressed;
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    final ctrl =
        pressed.contains(LogicalKeyboardKey.controlLeft) ||
        pressed.contains(LogicalKeyboardKey.controlRight);

    if (ctrl) {
      final now = DateTime.now().microsecondsSinceEpoch;
      if (now - _lastZoomUpdateTs < _zoomUpdateIntervalUs) return;
      _lastZoomUpdateTs = now;
      final factor = 1.0 + (-e.scrollDelta.dy) * 0.0015;
      final target = (_zoom * factor).clamp(_minZoom, _maxZoom);
      _applyZoom(target, focalGlobal: e.position);
    }
  }

  void _maybeAutoscroll(double localDyInColumn) {
    const double edge = 40.0;
    const double step = 12.0;

    if (!_vScroll.hasClients) return;

    final maxScroll = _vScroll.position.maxScrollExtent;
    final minScroll = _vScroll.position.minScrollExtent;
    final current = _vScroll.offset;

    if (localDyInColumn < edge && current > minScroll) {
      //print('localDyInColumn: $localDyInColumn, scrolling UP');
      final to = (current - step).clamp(minScroll, maxScroll);
      _vScroll.jumpTo(to);
    } else {
      final viewport = _vScroll.position.viewportDimension;
      //print('localDyInColumn: $localDyInColumn, viewport: $viewport');
      if (localDyInColumn > viewport - edge && current < maxScroll) {
        final to = (current + step).clamp(minScroll, maxScroll);
        _vScroll.jumpTo(to);
      }
    }
  }

  // void _onHorizontalSwipe(
  //   DragEndDetails d,
  //   VoidCallback nextDay,
  //   VoidCallback prevDay,
  // ) {
  //   // proste: prędkość w osi x
  //   final vx = d.velocity.pixelsPerSecond.dx;
  //   if (vx.abs() < 250) return;
  //   if (vx < 0) {
  //     // swipe w lewo -> następny dzień
  //     nextDay();
  //   } else {
  //     prevDay();
  //   }
  // }

  // ! Ghost
  final ValueNotifier<GhostState?> _ghost = ValueNotifier<GhostState?>(null);

  void _updateGhost(String day, DragData data, Offset globalOffset) {
    final key = dayKeys[day]!;
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final local = renderBox.globalToLocal(globalOffset);
    _maybeAutoscroll(
      local.dy -
          _vScroll.offset +
          (data.mode == DragMode.resize
              ? 0
              : (data.task.startTime == null
                    ? (_defaultDuration.inMinutes / 60) * _pixelsPerMinute
                    : _dateToHeight(data.task.startTime!, data.task.endTime!) /
                          2)),
    );

    double minutesFromTop = (local.dy / _pixelsPerMinute);
    minutesFromTop = minutesFromTop.clamp(
      0,
      (DetailedCalendar.halfHoursPerDay * 30).toDouble(),
    );
    final minutesRounded =
        (minutesFromTop / DetailedCalendar.snapMinutes).round() *
        DetailedCalendar.snapMinutes;

    final dayStart = weekStartDates[day]!;
    final columnBase = DateTime(dayStart.year, dayStart.month, dayStart.day);
    final snapped = columnBase.add(Duration(minutes: minutesRounded));

    DateTime ghostStart;
    double ghostHeight;

    if (data.mode == DragMode.move) {
      final Duration dur = data.task.duration ?? _defaultDuration;
      final end = snapped.add(dur);

      ghostStart = _snapMinutes(snapped);
      ghostHeight = _dateToHeight(ghostStart, end);
    } else {
      final taskDay = DateTime(
        data.task.startTime!.year,
        data.task.startTime!.month,
        data.task.startTime!.day,
      );
      final isSameColumnDay = isSameDay(taskDay, dayStart);
      if (!isSameColumnDay) {
        return;
      }
      ghostStart = data.task.startTime!;
      DateTime end = snapped.isAfter(ghostStart)
          ? snapped
          : ghostStart.add(
              const Duration(minutes: DetailedCalendar.minDurationMinutes),
            );
      end = _snapMinutes(end);

      final dayEnd = columnBase.add(const Duration(hours: 24));
      if (!end.isBefore(dayEnd)) {
        end = dayEnd.subtract(
          const Duration(minutes: DetailedCalendar.snapMinutes),
        );
      }

      ghostHeight = _dateToHeight(ghostStart, end);
    }

    _ghost.value = GhostState(
      day: day,
      start: ghostStart,
      height: ghostHeight,
      data: data,
    );
  }

  @override
  void dispose() {
    _vScroll.dispose();
    _ghost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Color bgTop = const Color(0xFFeef4ff);
    final Color bgBottom = const Color(0xFFdce7ff);
    final byDay = tasksByDay();
    final selectedDayIndex = widget.calendarStartDate.weekday - 1;
    final selectedDayKey = DetailedCalendar.weekdays[selectedDayIndex];
    final selectedDayLabel = _weekdayLabel(l10n, selectedDayIndex);

    return Listener(
      onPointerSignal: _onPointerSignal,

      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
        // onHorizontalDragEnd: (d) => _onHorizontalSwipe(
        //   d,
        //   () => context.read<CalendarCubit>().nextPeriod(),
        //   () => context.read<CalendarCubit>().previousPeriod(),
        // ),
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [bgTop, bgBottom],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(60, 8, 0, 6),
                child: widget.viewMode == CalendarViewMode.week
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          Text(
                            selectedDayLabel,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey.shade800,
                            ),
                          ),
                          Text(
                            '${widget.calendarStartDate.day}.${widget.calendarStartDate.month}.${widget.calendarStartDate.year}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.blueGrey.shade600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            width: 22,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
              ),
              Expanded(
                key: scrollKey,
                child: SingleChildScrollView(
                  key: _viewportKey,
                  controller: _vScroll,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: [
                            for (
                              int i = 0;
                              i < DetailedCalendar.halfHoursPerDay;
                              i++
                            )
                              SizedBox(
                                height: _halfHourHeight,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      '${i ~/ 2}:${i % 2 == 0 ? '00' : '30'}',
                                      style: TextStyle(
                                        color: i % 2 == 0
                                            ? Colors.black
                                            : Colors.grey.shade700,
                                        fontSize: i % 2 == 0 ? 16 : 11.5,
                                        fontWeight: i % 2 == 0
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: widget.viewMode == CalendarViewMode.week
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: DetailedCalendar.weekdays.map((day) {
                                  return Expanded(
                                    child: DayColumn(
                                      day: day,
                                      dayKey: dayKeys[day]!,
                                      dayStart: weekStartDates[day]!,
                                      halfHourHeight: _halfHourHeight,
                                      pixelsPerMinute: _pixelsPerMinute,
                                      tasksForDay: byDay[day]!,
                                      ghost: _ghost,

                                      onMoveGhost: _updateGhost,
                                      onLeaveGhost: () {
                                        final g = _ghost.value;
                                        if (g != null && g.day == day) {
                                          _ghost.value = null;
                                        }
                                      },
                                      onDrop: (data) async {
                                        final inst = data.task;

                                        final g = _ghost.value;
                                        if (g == null) return;

                                        final newStartUtc = g.start.toUtc();
                                        final newDuration = Duration(
                                          minutes: (g.height / _pixelsPerMinute)
                                              .round(),
                                        );

                                        final oldStartUtc = inst.rid
                                            ?.toUtc(); // u Ciebie tak
                                        await context
                                            .read<CalendarCubit>()
                                            .onTaskDrop(
                                              inst,
                                              oldStartUtc,
                                              newStartUtc,
                                              newDuration,
                                              context,
                                            );

                                        _ghost.value = null;
                                      },
                                    ),
                                  );
                                }).toList(),
                              )
                            : DayColumn(
                                day: selectedDayKey,
                                dayKey: dayKeys[selectedDayKey]!,
                                dayStart: widget.calendarStartDate,
                                halfHourHeight: _halfHourHeight,
                                pixelsPerMinute: _pixelsPerMinute,
                                tasksForDay: byDay[selectedDayKey]!,
                                ghost: _ghost,

                                onMoveGhost: _updateGhost,
                                onLeaveGhost: () {
                                  final g = _ghost.value;
                                  if (g != null && g.day == selectedDayKey) {
                                    _ghost.value = null;
                                  }
                                },
                                onDrop: (data) async {
                                  final inst = data.task;

                                  final g = _ghost.value;
                                  if (g == null) return;

                                  final newStartUtc = g.start.toUtc();
                                  final newDuration = Duration(
                                    minutes: (g.height / _pixelsPerMinute)
                                        .round(),
                                  );

                                  final oldStartUtc = inst.rid?.toUtc();
                                  await context
                                      .read<CalendarCubit>()
                                      .onTaskDrop(
                                        inst,
                                        oldStartUtc,
                                        newStartUtc,
                                        newDuration,
                                        context,
                                      );

                                  _ghost.value = null;
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
