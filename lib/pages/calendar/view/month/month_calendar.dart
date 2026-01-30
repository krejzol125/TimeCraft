import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_state.dart';
import 'package:timecraft/pages/calendar/view/detailed/detailed_calendar.dart';
import 'package:timecraft/repo/task_repo.dart';

class MonthToDetailPage extends StatefulWidget {
  const MonthToDetailPage({
    super.key,
    required this.repo,
    required this.tasks,
    required this.initialDate,
    required this.setSelectedDate,
    required this.setRange,
  });

  final TaskRepo repo;
  final List<TaskInstance> tasks;
  final DateTime initialDate;
  final void Function(DateTime) setSelectedDate;
  final void Function(DateTime) setRange;

  @override
  State<MonthToDetailPage> createState() => _MonthToDetailPageState();
}

class _MonthToDetailPageState extends State<MonthToDetailPage> {
  static const _stroke = Color(0xFFB9BFCC);
  static const _text = Color(0xFF111827);
  static const _subtext = Color(0xFF6B7280);
  static const _accent = Color(0xFF1F4AA8);

  @override
  void initState() {
    _selectedDay ??= widget.initialDate;
    _focusedDay = _selectedDay!;
    super.initState();
  }

  PageController? _calPageController;

  late DateTime _focusedDay = DateTime(
    widget.initialDate.year,
    widget.initialDate.month,
    1,
  );
  DateTime? _selectedDay;

  CalendarFormat _format = CalendarFormat.month;
  bool _showDetail = true;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<TaskInstance> _eventsForDay(DateTime day) {
    return widget.tasks
        .where((t) => t.startTime != null && _isSameDay(t.startTime!, day))
        .toList();
  }

  CalendarViewMode _detailViewModeForWidth(double w) =>
      w >= 720 ? CalendarViewMode.week : CalendarViewMode.day;

  DateTime _weekStart(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  void _openDetailFor(DateTime day, double width, {bool collapse = true}) {
    setState(() {
      _selectedDay = day;
      _focusedDay = day;

      widget.setSelectedDate(day);

      if (collapse) {
        _format = CalendarFormat.week;
        _showDetail = true;
      }
    });
  }

  void _backToMonth() {
    setState(() {
      _format = CalendarFormat.month;
      _showDetail = true;
    });
  }

  bool _headerHidden = false;
  double _lastOffset = 0;

  ScrollController _vScroll = ScrollController();
  void _attachHideOnScroll(ScrollController c) {
    if (!c.hasClients || identical(c, _vScroll)) return;
    _vScroll = c;

    _lastOffset = c.offset;

    c.addListener(() {
      final offset = c.offset;
      final delta = offset - _lastOffset;

      const threshold = 6.0;

      if (delta > threshold && !_headerHidden) {
        _format = CalendarFormat.week;
        _showDetail = true;
        _headerHidden = true;
        setState(() {});
      } else if (delta < -threshold && _headerHidden) {
        _headerHidden = false;
        if (offset <= 20) {
          _format = CalendarFormat.month;
          _showDetail = true;
        }
        setState(() {});
      }

      _lastOffset = offset;
    });
  }

  String _monthLabel(AppLocalizations l10n, DateTime d) {
    final months = [
      l10n.monthJanuary,
      l10n.monthFebruary,
      l10n.monthMarch,
      l10n.monthApril,
      l10n.monthMay,
      l10n.monthJune,
      l10n.monthJuly,
      l10n.monthAugust,
      l10n.monthSeptember,
      l10n.monthOctober,
      l10n.monthNovember,
      l10n.monthDecember,
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final Color bgTop = const Color(0xFFeef4ff);
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, c) {
        final width = c.maxWidth;
        final detailMode = _detailViewModeForWidth(width);

        final anchorDay = _selectedDay ?? widget.initialDate;
        final calendarStartDate = (detailMode == CalendarViewMode.week)
            ? _weekStart(anchorDay)
            : DateTime(anchorDay.year, anchorDay.month, anchorDay.day);

        return Column(
          children: [
            Container(
              padding: detailMode == CalendarViewMode.day
                  ? const EdgeInsets.fromLTRB(14, 12, 14, 12)
                  : null,
              decoration: BoxDecoration(
                color: bgTop.withValues(alpha: 0.92),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ],
              ),
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy > 0) {
                    _backToMonth();
                  }
                  if (details.velocity.pixelsPerSecond.dy < 0) {
                    _openDetailFor(_selectedDay ?? widget.initialDate, width);
                  }
                },
                child: TableCalendar<TaskInstance>(
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),

                  focusedDay: _focusedDay,
                  calendarFormat: _format,

                  availableCalendarFormats: {
                    CalendarFormat.month: l10n.calendarMonth,
                    CalendarFormat.week: l10n.calendarWeek,
                  },

                  selectedDayPredicate: (day) =>
                      _selectedDay != null && _isSameDay(day, _selectedDay!),

                  eventLoader: _eventsForDay,

                  onDaySelected: (selectedDay, focusedDay) {
                    _openDetailFor(selectedDay, width);
                  },

                  onPageChanged: (focusedDay) {
                    setState(() => _focusedDay = focusedDay);
                    widget.setRange(focusedDay);
                    if (detailMode == CalendarViewMode.week) {
                      _openDetailFor(focusedDay, width, collapse: false);
                    }
                  },

                  onCalendarCreated: (controller) {
                    _calPageController = controller;
                  },

                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    headerPadding: const EdgeInsets.symmetric(vertical: 4),
                    titleTextStyle: const TextStyle(
                      color: _text,
                      fontWeight: FontWeight.w900,
                      fontSize: 15.5,
                    ),
                  ),

                  daysOfWeekHeight: 22,
                  rowHeight: 44,

                  calendarStyle: CalendarStyle(
                    markersMaxCount: 0,
                    outsideDaysVisible: true,
                    isTodayHighlighted: false,
                    tablePadding: EdgeInsets.fromLTRB(
                      detailMode == CalendarViewMode.week ? 60 : 0,
                      0,
                      0,
                      0,
                    ),
                  ),

                  calendarBuilders: CalendarBuilders<TaskInstance>(
                    headerTitleBuilder: (context, day) {
                      return AnimatedSlide(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        offset: _headerHidden
                            ? const Offset(0, -0.08)
                            : Offset.zero,
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 180),
                          crossFadeState: _headerHidden
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: const SizedBox(height: 0),
                          secondChild: IgnorePointer(
                            ignoring: _headerHidden,
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                _ChevronButton(
                                  icon: Icons.chevron_left_rounded,
                                  onTap: () => _calPageController?.previousPage(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      _monthLabel(l10n, day),
                                      style: const TextStyle(
                                        color: _text,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15.5,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_showDetail)
                                  _SmallPillButton(
                                    icon: Icons.calendar_month_rounded,
                                    label: l10n.calendarMonth,
                                    onTap: _backToMonth,
                                  ),
                                const SizedBox(width: 8),
                                _ChevronButton(
                                  icon: Icons.chevron_right_rounded,
                                  onTap: () => _calPageController?.nextPage(
                                    duration: const Duration(milliseconds: 220),
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                      );
                    },

                    dowBuilder: (context, day) {
                      final labels = [
                        l10n.weekdayMonShort,
                        l10n.weekdayTueShort,
                        l10n.weekdayWedShort,
                        l10n.weekdayThuShort,
                        l10n.weekdayFriShort,
                        l10n.weekdaySatShort,
                        l10n.weekdaySunShort,
                      ];
                      final idx = day.weekday - 1;
                      final isWeekend =
                          day.weekday == DateTime.saturday ||
                          day.weekday == DateTime.sunday;

                      return Center(
                        child: Text(
                          labels[idx],
                          style: TextStyle(
                            color: isWeekend
                                ? _subtext.withValues(alpha: 0.9)
                                : _subtext.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 0.2,
                          ),
                        ),
                      );
                    },

                    defaultBuilder: (context, day, _) => _DayCell(
                      day: day,
                      state: _DayCellState.normal,
                      markers: _eventsForDay(day).length,
                    ),
                    todayBuilder: (context, day, _) => _DayCell(
                      day: day,
                      state: _DayCellState.today,
                      markers: _eventsForDay(day).length,
                    ),
                    selectedBuilder: (context, day, _) => _DayCell(
                      day: day,
                      state: _DayCellState.selected,
                      markers: _eventsForDay(day).length,
                    ),
                    outsideBuilder: (context, day, _) => _DayCell(
                      day: day,
                      state: _DayCellState.outside,
                      markers: _eventsForDay(day).length,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: _showDetail
                    ? DetailedCalendar(
                        widget.tasks,
                        calendarStartDate,
                        widget.repo,
                        detailMode,
                        onScrollControllerReady: _attachHideOnScroll,
                        key: const ValueKey('detail'),
                      )
                    : const _MonthHint(key: ValueKey('hint')),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MonthHint extends StatelessWidget {
  const _MonthHint({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Text(
        l10n.monthHint,
        style: TextStyle(
          color: Colors.blueGrey.shade700,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  static const _stroke = _MonthToDetailPageState._stroke;
  static const _text = _MonthToDetailPageState._text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 36,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _stroke.withValues(alpha: 0.85)),
          ),
          child: Icon(icon, color: _text),
        ),
      ),
    );
  }
}

class _SmallPillButton extends StatelessWidget {
  const _SmallPillButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const _accent = _MonthToDetailPageState._accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _accent.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _accent.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: _accent),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: _accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _DayCellState { normal, today, selected, outside }

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.state,
    required this.markers,
  });

  final DateTime day;
  final _DayCellState state;
  final int markers;

  static const _stroke = _MonthToDetailPageState._stroke;
  static const _text = _MonthToDetailPageState._text;
  static const _subtext = _MonthToDetailPageState._subtext;
  static const _accent = _MonthToDetailPageState._accent;

  @override
  Widget build(BuildContext context) {
    final isSelected = state == _DayCellState.selected;
    final isToday = state == _DayCellState.today;
    final isOutside = state == _DayCellState.outside;

    final bg = isSelected
        ? _accent.withValues(alpha: 0.12)
        : isToday
        ? Colors.white.withValues(alpha: 0.65)
        : Colors.white.withValues(alpha: 0.35);

    final border = isSelected
        ? _accent.withValues(alpha: 0.55)
        : _stroke.withValues(alpha: 0.75);

    final textColor = isOutside
        ? _subtext.withValues(alpha: 0.55)
        : (isSelected ? _accent : _text);

    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w900,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 4),
            _MarkersRow(count: markers),
          ],
        ),
      ),
    );
  }
}

class _MarkersRow extends StatelessWidget {
  const _MarkersRow({required this.count});

  final int count;

  static const _accent = _MonthToDetailPageState._accent;

  @override
  Widget build(BuildContext context) {
    final n = count.clamp(0, 3);
    if (n == 0) return const SizedBox(height: 6);

    return SizedBox(
      height: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(n, (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.2),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: _accent.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}
