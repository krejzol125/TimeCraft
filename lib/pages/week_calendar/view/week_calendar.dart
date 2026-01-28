import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timecraft/components/scope_dialog.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/week_calendar/view/ghost_tile.dart';
import 'package:timecraft/pages/week_calendar/view/task_tile.dart';
import 'package:timecraft/repo/task_repo.dart';

class WeekCalendar extends StatefulWidget {
  const WeekCalendar(this.tasks, this.weekStartDate, this.repo, {super.key});

  final TaskRepo repo;

  final double baseHalfHourHeight = 40.0;
  final int halfHoursPerDay = 48;
  final List<String> weekdays = const [
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

  final DateTime weekStartDate;

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  _WeekCalendarState();

  @override
  void initState() {
    super.initState();
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

  DateTime get weekStartDate => widget.weekStartDate;

  late final Map<String, DateTime> weekStartDates = {
    'Mon': weekStartDate,
    'Tue': weekStartDate.add(const Duration(days: 1)),
    'Wed': weekStartDate.add(const Duration(days: 2)),
    'Thu': weekStartDate.add(const Duration(days: 3)),
    'Fri': weekStartDate.add(const Duration(days: 4)),
    'Sat': weekStartDate.add(const Duration(days: 5)),
    'Sun': weekStartDate.add(const Duration(days: 6)),
  };

  bool isSameDay(DateTime date1, DateTime date2) =>
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;

  double _dateToTopOffset(DateTime startTime) =>
      (startTime.hour * 60 + startTime.minute) * _pixelsPerMinute;

  double _dateToHeight(DateTime startTime, DateTime endTime) {
    final minutes = endTime.difference(startTime).inMinutes;
    return minutes * _pixelsPerMinute;
  }

  DateTime _snapMinutes(DateTime dt) {
    final total = dt.hour * 60 + dt.minute;
    final snapped =
        (total / WeekCalendar.snapMinutes).round() * WeekCalendar.snapMinutes;
    final h = snapped ~/ 60;
    final m = snapped % 60;
    return DateTime(dt.year, dt.month, dt.day, h, m);
  }

  static const Duration _defaultDuration = Duration(minutes: 60);

  // ! Zoom

  double _zoom = 1.0;
  static const double _minZoom = 0.5;
  static const double _maxZoom = 3.0;
  double get _halfHourHeight => widget.baseHalfHourHeight * _zoom;
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

    final oldPPM = widget.baseHalfHourHeight * _zoom / 30.0;
    final newPPM = widget.baseHalfHourHeight * newZoom / 30.0;

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

    final pressed = RawKeyboard.instance.keysPressed;
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

  // ! Ghost
  String? _ghostDay;
  DateTime? _ghostStart;
  double? _ghostHeight;
  DragData? _ghostData;

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
      (widget.halfHoursPerDay * 30).toDouble(),
    );
    final minutesRounded =
        (minutesFromTop / WeekCalendar.snapMinutes).round() *
        WeekCalendar.snapMinutes;

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
              const Duration(minutes: WeekCalendar.minDurationMinutes),
            );
      end = _snapMinutes(end);

      final dayEnd = columnBase.add(const Duration(hours: 24));
      if (!end.isBefore(dayEnd))
        end = dayEnd.subtract(
          const Duration(minutes: WeekCalendar.snapMinutes),
        );

      ghostHeight = _dateToHeight(ghostStart, end);
    }

    setState(() {
      _ghostDay = day;
      _ghostStart = ghostStart;
      _ghostHeight = ghostHeight;
      _ghostData = data;
    });
  }

  void _clearGhost() {
    setState(() {
      _ghostDay = null;
      _ghostStart = null;
      _ghostHeight = null;
      _ghostData = null;
    });
  }

  Widget _buildDayColumn(String day) {
    final dayKey = dayKeys[day]!;
    return Flexible(
      child: Container(
        key: dayKey,
        height: _halfHourHeight * widget.halfHoursPerDay,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: DragTarget<DragData>(
          onMove: (details) {
            _updateGhost(day, details.data, details.offset);
          },
          onLeave: (data) {
            if (_ghostDay == day) _clearGhost();
          },
          onAcceptWithDetails: (details) async {
            final data = details.data;
            final inst = data.task;

            final newStartUtc = _ghostStart!.toUtc();
            final newDuration = Duration(
              minutes: (_ghostHeight! / _pixelsPerMinute).round(),
            );

            DateTime? oldStartUtc = inst.rid?.toUtc();

            if (inst.isRepeating == false || oldStartUtc == null) {
              await widget.repo.schedulePattern(
                inst.taskId,
                newStartUtc,
                newDuration,
              );
              _clearGhost();
              return;
            }
            final offset = newStartUtc.difference(oldStartUtc);

            final scope = await showMoveScopeDialog(context);
            if (scope == null) {
              _clearGhost();
              return;
            }

            switch (scope) {
              case RecurrenceMoveScope.singleOccurrence:
                await widget.repo.rescheduleOneInstancePattern(
                  inst.taskId,
                  inst.rid!,
                  newStartUtc,
                  newDuration,
                );
                break;

              case RecurrenceMoveScope.thisAndFuture:
                await widget.repo.rescheduleThisAndFuturePattern(
                  inst.taskId,
                  inst.rid!,
                  offset,
                  newDuration,
                );
                break;

              case RecurrenceMoveScope.entireSeries:
                await widget.repo.rescheduleAllPattern(
                  inst.taskId,
                  offset,
                  newDuration,
                  fromWeekday: inst.startTime?.weekday,
                );
                break;
            }
            _clearGhost();
          },

          builder: (context, candidateItems, rejectedItems) {
            return Stack(
              children: [
                ...List.generate(
                  widget.halfHoursPerDay,
                  (i) => Positioned(
                    top: i * _halfHourHeight,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: _halfHourHeight,
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 0.8,
                          ),
                        ),
                        color: i % 2 == 1
                            ? Colors.blueGrey.withValues(alpha: 0.015)
                            : Colors.transparent,
                      ),
                    ),
                  ),
                ),

                ...widget.tasks
                    .where(
                      (e) =>
                          e.startTime != null &&
                          isSameDay(e.startTime!, weekStartDates[day]!),
                    )
                    .map((event) {
                      final top = _dateToTopOffset(event.startTime!);
                      final height = _dateToHeight(
                        event.startTime!,
                        event.endTime!,
                      );
                      return Positioned(
                        top: top,
                        left: 2,
                        right: 2,
                        child: TaskTile(task: event, height: height),
                      );
                    }),

                if (_ghostDay == day &&
                    _ghostStart != null &&
                    _ghostHeight != null &&
                    _ghostData != null)
                  Positioned(
                    top: _dateToTopOffset(
                      _ghostData!.mode == DragMode.move
                          ? _ghostStart!
                          : _ghostData!.task.startTime!,
                    ),
                    left: 2,
                    right: 2,
                    child: IgnorePointer(
                      child: GhostTile(
                        title: _ghostData!.task.title,
                        height: _ghostHeight!,
                        start: _ghostStart!,
                        end: () {
                          if (_ghostData!.mode == DragMode.move) {
                            final dur =
                                _ghostData!.task.duration ?? _defaultDuration;
                            return _ghostStart!.add(dur);
                          } else {
                            final minutes = (_ghostHeight! / _pixelsPerMinute)
                                .round();
                            return _ghostData!.task.startTime!.add(
                              Duration(minutes: minutes),
                            );
                          }
                        }(),
                        mode: _ghostData!.mode,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _vScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgTop = const Color(0xFFeef4ff);
    final Color bgBottom = const Color(0xFFdce7ff);
    return Listener(
      onPointerSignal: _onPointerSignal,

      child: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        onScaleEnd: _onScaleEnd,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.weekdays.map((d) {
                    return Column(
                      children: [
                        Text(
                          d,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                        Text(
                          '${weekStartDates[d]!.day}.${weekStartDates[d]!.month}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.blueGrey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 18,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
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
                            for (int i = 0; i < widget.halfHoursPerDay; i++)
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: widget.weekdays
                              .map((day) => _buildDayColumn(day))
                              .toList(),
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

class WeekLoading extends StatelessWidget {
  const WeekLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
