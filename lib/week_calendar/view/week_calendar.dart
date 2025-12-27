import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/app_view/bloc/app_cubit.dart';
import 'package:timecraft/week_calendar/view/ghost_tile.dart';
import 'package:timecraft/week_calendar/view/task_tile.dart';

/// ================================================

class Weekcalendar extends StatefulWidget {
  Weekcalendar(this.tasks, {super.key});

  // Wysokość 30 minut
  //final double halfHourHeight = 40.0;
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
  List<TaskInstance> tasks = [];

  // Snapping co ile minut
  static const int snapMinutes = 5;
  // Minimalna długość zadania
  static const int minDurationMinutes = 10;

  @override
  State<Weekcalendar> createState() => _WeekcalendarState();
}

class _WeekcalendarState extends State<Weekcalendar> {
  _WeekcalendarState();

  @override
  void initState() {
    tasks = widget.tasks;
    super.initState();
  }

  final double dayWidth = 100.0;

  // Pionowy kontroler przewijania (dla auto-scrolla)
  final ScrollController _vScroll = ScrollController();

  // Klucze kolumn – do przeliczania globalnych koordynatów na lokalne
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

  late List<TaskInstance> tasks = [];

  // Prosty seed
  // List<TaskInstance> tasks = [
  //   TaskInstance(
  //     id: 1,
  //     title: "Design Meeting",
  //     description: "Discuss UI/UX designs with the team.",
  //     startTime: _thisWeekStart().add(const Duration(hours: 9)), // Pon 09:00
  //     endTime: _thisWeekStart().add(const Duration(hours: 10)), // Pon 10:00
  //   ),
  //   TaskInstance(
  //     id: 2,
  //     title: "Code Review",
  //     description: "Review code with the team.",
  //     startTime: _thisWeekStart().add(
  //       const Duration(hours: 14, days: 3),
  //     ), // Czw 14:00
  //     endTime: _thisWeekStart().add(
  //       const Duration(hours: 16, days: 3),
  //     ), // Czw 16:00
  //   ),
  //   TaskInstance(
  //     id: 3,
  //     title: "Meeting",
  //     description: "Discuss project progress with the team.",
  //     startTime: _thisWeekStart().add(
  //       const Duration(hours: 10, days: 3),
  //     ), // Czw 10:00
  //     endTime: _thisWeekStart().add(
  //       const Duration(hours: 11, days: 3),
  //     ), // Czw 11:00
  //   ),
  //   TaskInstance(
  //     id: 4,
  //     title: "Meeting",
  //     description: "Discuss project progress with the team.",
  //     startTime: _thisWeekStart().add(
  //       const Duration(hours: 12, days: 3),
  //     ), // Czw 12:00
  //     endTime: _thisWeekStart().add(
  //       const Duration(hours: 13, days: 3),
  //     ), // Czw 13:00
  //   ),
  //   TaskInstance(
  //     id: 5,
  //     title: "Meeting",
  //     description: "Discuss project progress with the team.",
  //     startTime: _thisWeekStart().add(
  //       const Duration(hours: 14, days: 2),
  //     ), // sr 14:00
  //     endTime: _thisWeekStart().add(
  //       const Duration(hours: 15, days: 2),
  //     ), // sr 15:00
  //   ),
  //   TaskInstance(
  //     id: 6,
  //     title: "Meeting",
  //     description: "Discuss project progress with the team.",
  //     startTime: _thisWeekStart().add(
  //       const Duration(hours: 16, days: 1),
  //     ), // wt 16:00
  //     endTime: _thisWeekStart().add(
  //       const Duration(hours: 17, days: 1),
  //     ), // wt 17:00
  //   ),
  // ];

  // Ghost (cień) – aktualizowany na żywo podczas drag
  String? _ghostDay;
  DateTime? _ghostStart;
  double? _ghostHeight;
  DragData? _ghostData; // zadanie + tryb (move/resize)

  // Początek tygodnia (poniedziałek)
  static DateTime _thisWeekStart() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  DateTime get weekStartDate => _thisWeekStart();

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

  // Ile pikseli ma 1 minuta (na podstawie halfHourHeight)
  //double get _pixelsPerMinute => _halfHourHeight / 30.0;

  // Przeliczenia czasu na pozycję i wysokość
  double _dateToTopOffset(DateTime startTime) =>
      (startTime.hour * 60 + startTime.minute) * _pixelsPerMinute;

  double _dateToHeight(DateTime startTime, DateTime endTime) {
    final minutes = endTime.difference(startTime).inMinutes;
    return minutes * _pixelsPerMinute;
  }

  DateTime _snapTo5(DateTime dt) {
    final total = dt.hour * 60 + dt.minute;
    final snapped =
        (total / Weekcalendar.snapMinutes).round() * Weekcalendar.snapMinutes;
    final h = snapped ~/ 60;
    final m = snapped % 60;
    return DateTime(dt.year, dt.month, dt.day, h, m);
  }

  static const Duration _defaultDuration = Duration(minutes: 60);

  void _updateTaskTime(TaskInstance t, DateTime newStart) {
    // jeśli zadanie nie ma czasu, przyjmij domyślną długość
    final Duration dur = t.duration ?? _defaultDuration;
    final DateTime newEnd = newStart.add(dur);

    setState(() {
      final idx = tasks.indexWhere((x) => x.id == t.id);
      if (idx != -1) {
        tasks[idx] = tasks[idx].copyWith(startTime: newStart, endTime: newEnd);
      }
    });
  }

  void _updateTaskEnd(TaskInstance t, DateTime newEnd) {
    // Minimalna długość
    final minEnd = t.startTime!.add(
      const Duration(minutes: Weekcalendar.minDurationMinutes),
    );
    final safeEnd = newEnd.isAfter(minEnd) ? newEnd : minEnd;
    setState(() {
      final idx = tasks.indexWhere((x) => x.id == t.id);
      if (idx != -1) {
        tasks[idx] = tasks[idx].copyWith(endTime: safeEnd);
      }
    });
  }

  // --- ZOOM ---
  double _zoom = 1.0; // aktualny zoom
  static const double _minZoom = 0.5; // 20 px / 30 min (przy base=40)
  static const double _maxZoom = 3.0; // 120 px / 30 min
  double get _halfHourHeight => widget.baseHalfHourHeight * _zoom;
  double get _pixelsPerMinute => _halfHourHeight / 30.0;
  final GlobalKey _viewportKey = GlobalKey();

  // Do pinch-zoom
  double? _scaleStartZoom;
  // Offset? _scaleStartFocalGlobal;

  // --- ZOOM: stosowanie z kotwicą pod palcem/kursorem ---
  void _applyZoom(double targetZoom, {required Offset focalGlobal}) {
    final rb = scrollKey.currentContext?.findRenderObject() as RenderBox?;
    if (rb == null || !_vScroll.hasClients) {
      setState(() => _zoom = targetZoom.clamp(_minZoom, _maxZoom));
      return;
    }

    final newZoom = targetZoom.clamp(_minZoom, _maxZoom);
    if ((newZoom - _zoom).abs() < 0.0001) return;

    // final viewportTopGlobal = rb.localToGlobal(Offset.zero).dy;
    // final localY = (focalGlobal.dy - viewportTopGlobal).clamp(
    //   0.0,
    //   rb.size.height,
    // );

    final localY = rb.globalToLocal(focalGlobal).dy;

    // final newZoom = targetZoom.clamp(_minZoom, _maxZoom);
    // if ((newZoom - _zoom).abs() < 0.0001) return;

    // 1) lokalne Y w viewportcie
    // final viewportTopGlobal = rb.localToGlobal(Offset.zero).dy;
    //final localY = (focalGlobal.dy - viewportTopGlobal).clamp(0.0, rb.size.height);

    // 2) przelicz offset bez czekania na klatkę
    final oldPPM = widget.baseHalfHourHeight * _zoom / 30.0;
    final newPPM = widget.baseHalfHourHeight * newZoom / 30.0;

    final contentYBefore = _vScroll.offset + localY;
    final minutesAtFocal = contentYBefore / oldPPM;
    final contentYAfter = minutesAtFocal * newPPM;
    final wantedOffset = contentYAfter - localY;

    // 3) zastosuj atomowo
    setState(() => _zoom = newZoom);

    final minScroll = _vScroll.position.minScrollExtent;
    final maxScroll = _vScroll.position.maxScrollExtent;
    //print('minutes at focal: $minutesAtFocal');
    //print('offset before: ${_vScroll.offset}, wanted: $wantedOffset');
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (!_vScroll.hasClients) return;
      _vScroll.jumpTo(wantedOffset.clamp(minScroll, maxScroll));
    });
  }

  // --- PINCH (uszczypnięcie dwoma palcami) ---
  void _onScaleStart(ScaleStartDetails d) {
    _scaleStartZoom = _zoom;
    // _scaleStartFocalGlobal = d.focalPoint;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    // Pinch: używamy tylko skali (ignorujemy przesunięcia)
    final base = _scaleStartZoom ?? _zoom;
    final focal = d.focalPoint; // aktualna pozycja palców
    _applyZoom(base * d.scale, focalGlobal: focal);
  }

  void _onScaleEnd(ScaleEndDetails d) {
    _scaleStartZoom = null;
    // _scaleStartFocalGlobal = null;
  }

  int _lastZoomUpdateTs = 0; // microseconds
  static const int _zoomUpdateIntervalUs = 16 * 1000; // ~60 FPS

  // --- ZOOM kółkiem z CTRL ---
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
      // delta.dy < 0 → zoom in
      final factor = 1.0 + (-e.scrollDelta.dy) * 0.0015; // czułość
      final target = (_zoom * factor).clamp(_minZoom, _maxZoom);
      _applyZoom(target, focalGlobal: e.position);
    } else {
      // zwykłe przewijanie
      // if (!_vScroll.hasClients) return;
      // final minScroll = _vScroll.position.minScrollExtent;
      // final maxScroll = _vScroll.position.maxScrollExtent;
      // final next = (_vScroll.offset + e.scrollDelta.dy).clamp(
      //   minScroll,
      //   maxScroll,
      // );
      // _vScroll.jumpTo(next);
    }
  }

  // Auto-scroll gdy kursor blisko krawędzi widoku
  void _maybeAutoscroll(double localDyInColumn) {
    const double edge = 40.0; // strefa wyzwalająca auto-scroll
    const double step = 12.0; // krok scrolla

    // Top/bottom granice wewnątrz scrolla
    if (!_vScroll.hasClients) return;

    final maxScroll = _vScroll.position.maxScrollExtent;
    final minScroll = _vScroll.position.minScrollExtent;
    final current = _vScroll.offset;

    // Column height jest zwykle równe pełnej zawartości (duże), ale nas interesuje pozycja kursora wewnątrz kolumny (local.dy)
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

  // Aktualizacja ghosta zależna od trybu
  void _updateGhost(String day, DragData data, Offset globalOffset) {
    final key = dayKeys[day]!;
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final local = renderBox.globalToLocal(globalOffset);
    // final localForAutoScroll = renderBox.globalToLocal(
    //   globalOffset - Offset(0, _vScroll.offset),
    // );
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

    // Minuty od góry kolumny (ciągłe)
    double minutesFromTop = (local.dy / _pixelsPerMinute);
    // Clamp do zakresu dnia
    minutesFromTop = minutesFromTop.clamp(
      0,
      (widget.halfHoursPerDay * 30).toDouble(),
    );
    final minutesRounded =
        (minutesFromTop / Weekcalendar.snapMinutes).round() *
        Weekcalendar.snapMinutes;

    final dayStart = weekStartDates[day]!;
    final columnBase = DateTime(dayStart.year, dayStart.month, dayStart.day);
    final snapped = columnBase.add(Duration(minutes: minutesRounded));

    DateTime ghostStart;
    double ghostHeight;

    if (data.mode == DragMode.move) {
      // Przenoszenie: start = snapped, wysokość zachowana
      //final duration = data.task.endTime!.difference(data.task.startTime!);
      final Duration dur = data.task.duration ?? _defaultDuration;
      final end = snapped.add(dur);

      ghostStart = _snapTo5(snapped);
      ghostHeight = _dateToHeight(ghostStart, end);
    } else {
      // Rozciąganie: dozwolone tylko w tym samym dniu co start taska
      final taskDay = DateTime(
        data.task.startTime!.year,
        data.task.startTime!.month,
        data.task.startTime!.day,
      );
      final isSameColumnDay = isSameDay(taskDay, dayStart);
      if (!isSameColumnDay) {
        // ignoruj ruch w innych kolumnach przy resize
        return;
      }
      ghostStart = data.task.startTime!;
      DateTime end = snapped.isAfter(ghostStart)
          ? snapped
          : ghostStart.add(
              const Duration(minutes: Weekcalendar.minDurationMinutes),
            );
      end = _snapTo5(end);

      // Bez wychodzenia poza dzień (opcjonalne ograniczenie)
      final dayEnd = columnBase.add(const Duration(hours: 24));
      if (!end.isBefore(dayEnd))
        end = dayEnd.subtract(
          const Duration(minutes: Weekcalendar.snapMinutes),
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
    if (_ghostDay != null ||
        _ghostStart != null ||
        _ghostHeight != null ||
        _ghostData != null) {
      setState(() {
        _ghostDay = null;
        _ghostStart = null;
        _ghostHeight = null;
        _ghostData = null;
      });
    }
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
          //onWillAccept: (t) => true,
          onMove: (details) {
            _updateGhost(day, details.data, details.offset);
          },
          onLeave: (data) {
            // tylko czyść, jeśli ghost był z tego dnia
            if (_ghostDay == day) _clearGhost();
          },
          onAcceptWithDetails: (details) {
            if (_ghostData == null || _ghostStart == null) return;

            final data = details.data;
            if (data.mode == DragMode.move) {
              // Zastosuj przeniesienie: start = ghostStart, end = start + stara długość
              _updateTaskTime(data.task, _ghostStart!);
            } else {
              // Zastosuj rozciągnięcie (ten sam dzień co start)
              final start = data.task.startTime!;
              DateTime end = start.add(
                Duration(minutes: (_ghostHeight! / _pixelsPerMinute).round()),
              );
              // Bezpieczny minimalny czas + snap
              final minEnd = start.add(
                const Duration(minutes: Weekcalendar.minDurationMinutes),
              );
              if (!end.isAfter(minEnd)) end = minEnd;
              end = _snapTo5(end);
              _updateTaskEnd(data.task, end);
            }
            context.read<AppCubit>().updateTask(
              tasks.where((t) => t.id == data.task.id).first,
            );
            _clearGhost();
          },
          builder: (context, candidateItems, rejectedItems) {
            return Stack(
              children: [
                // Siatka co 30 min
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

                // Istniejące taski w tym dniu
                ...tasks
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

                // GHOST – pokazuj tylko w aktywnej kolumnie
                if (_ghostDay == day &&
                    _ghostStart != null &&
                    _ghostHeight != null &&
                    _ghostData != null)
                  Positioned(
                    top: _dateToTopOffset(
                      _ghostData!.mode == DragMode.move
                          ? _ghostStart!
                          : _ghostData!
                                .task
                                .startTime!, // przy resize top = stały start
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
                            final dur = _ghostData!.task.startTime == null
                                ? _defaultDuration
                                : _ghostData!.task.endTime!.difference(
                                    _ghostData!.task.startTime!,
                                  );
                            return _ghostStart!.add(dur);
                          } else {
                            // z wysokości ghosta → minuty → koniec
                            final minutes = (_ghostHeight! / _pixelsPerMinute)
                                .round();
                            return _ghostData!.task.startTime!.add(
                              Duration(minutes: minutes),
                            );
                          }
                        }(), // resize
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
              // Nagłówki dni
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
              // Oś czasu + kolumny
              Expanded(
                key: scrollKey,
                child: SingleChildScrollView(
                  //physics: NeverScrollableScrollPhysics(),
                  key: _viewportKey,
                  controller: _vScroll,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Godziny po lewej
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
                      // Kolumny dni
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
