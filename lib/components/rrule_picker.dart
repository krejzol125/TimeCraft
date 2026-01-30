import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:rrule/rrule.dart';
import 'package:timecraft/components/date_time_field.dart';
import 'package:timecraft/system_design/tc_input_decorator.dart';
import 'package:timecraft/system_design/tc_radio_picker.dart';
import 'package:timecraft/system_design/tc_stepper.dart';

class RRulePicker extends StatefulWidget {
  const RRulePicker({
    super.key,
    required this.initialStartLocal,
    required this.onChanged,
    this.initialRrule,
  });

  final DateTime initialStartLocal;

  final RecurrenceRule? initialRrule;

  final ValueChanged<RecurrenceRule?> onChanged;

  @override
  State<RRulePicker> createState() => _RRulePickerState();
}

enum _EndMode { never, until, count }

class _RRulePickerState extends State<RRulePicker> {
  Frequency _freq = Frequency.weekly;
  int _interval = 1;

  final Set<ByWeekDayEntry> _byDay = {ByWeekDayEntry(1)};

  _EndMode _endMode = _EndMode.never;
  DateTime? _untilLocal;
  int _count = 10;

  @override
  void initState() {
    super.initState();
    if (widget.initialRrule != null) {
      _parseInitial(widget.initialRrule!);
    } else {
      final wd = ByWeekDayEntry(widget.initialStartLocal.weekday);
      _byDay
        ..clear()
        ..add(wd);
    }
  }

  void _emit() {
    widget.onChanged(
      RecurrenceRule(
        frequency: _freq,
        interval: _interval,
        byWeekDays: _freq == Frequency.weekly ? _byDay.toList() : [],
        until: _endMode == _EndMode.until && _untilLocal != null
            ? _untilLocal!.toUtc()
            : null,
        count: _endMode == _EndMode.count ? _count : null,
      ),
    );
  }

  void _parseInitial(RecurrenceRule rrule) {
    _freq = rrule.frequency;
    _interval = rrule.interval ?? 1;
    if (rrule.byWeekDays.isNotEmpty) {
      _byDay
        ..clear()
        ..addAll(rrule.byWeekDays);
    }

    if (rrule.count != null) {
      _endMode = _EndMode.count;
      _count = rrule.count ?? 10;
    } else if (rrule.until != null) {
      _endMode = _EndMode.until;
      final untilUtc = rrule.until;
      if (untilUtc != null) _untilLocal = untilUtc.toLocal();
    } else {
      _endMode = _EndMode.never;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TcInputDecorator(
      labelText: l10n.repeat,
      prefixIcon: const Icon(Icons.repeat_rounded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const SizedBox(height: 8),

              TcRadioPicker(
                items: [
                  (Frequency.daily, l10n.daily),
                  (Frequency.weekly, l10n.weekly),
                  (Frequency.monthly, l10n.monthly),
                  (Frequency.yearly, l10n.yearly),
                ],
                value: _freq,
                onChanged: (f) {
                  setState(() {
                    _freq = f;
                    if (_freq == Frequency.weekly && _byDay.isEmpty) {
                      _byDay.add(
                        ByWeekDayEntry(widget.initialStartLocal.weekday),
                      );
                    }
                  });
                  _emit();
                },
              ),

              if (_freq == Frequency.weekly) ...[
                const SizedBox(height: 10),
                _WeekdayChips(
                  l10n: l10n,
                  selected: _byDay,
                  onToggle: (token) {
                    setState(() {
                      if (_byDay.contains(token)) {
                        _byDay.remove(token);
                      } else {
                        _byDay.add(token);
                      }
                    });
                    _emit();
                  },
                ),
              ],
              const SizedBox(height: 12),

              Flex(
                direction: MediaQuery.of(context).size.width > 750
                    ? Axis.horizontal
                    : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: TcInputDecorator(
                      labelText: l10n.interval,
                      child: Row(
                        children: [
                          Text(l10n.every),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Center(
                              child: TcStepper(
                                value: _interval,
                                min: 1,
                                max: 365,
                                onChanged: (v) {
                                  setState(() => _interval = v);
                                  _emit();
                                },
                              ),
                            ),
                          ),
                          if (MediaQuery.of(context).size.width > 600) ...[
                            const SizedBox(width: 12),
                            Text(_intervalLabel(l10n, _freq, _interval)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8, height: 8),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: TcInputDecorator(
                      labelText: l10n.limit,
                      child: Column(
                        children: [
                          _EndModeRow(
                            l10n: l10n,
                            mode: _endMode,
                            onChanged: (m) {
                              setState(() {
                                _endMode = m;
                                if (_endMode == _EndMode.until) {
                                  _untilLocal ??= widget.initialStartLocal.add(
                                    const Duration(days: 30),
                                  );
                                }
                              });
                              _emit();
                            },
                          ),
                          if (_endMode == _EndMode.until) ...[
                            const SizedBox(height: 10),
                            DateTimeField(
                              label: l10n.endDate,
                              value: _untilLocal,
                              onPick: (dt) => setState(() {
                                _untilLocal = dt;
                                _emit();
                              }),
                              onClear: () {
                                setState(() => _untilLocal = null);
                                _emit();
                              },
                            ),
                          ],

                          if (_endMode == _EndMode.count) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Text(
                                  l10n.occurrences,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const Spacer(),
                                TcStepper(
                                  value: _count,
                                  min: 1,
                                  max: 9999,
                                  onChanged: (v) {
                                    setState(() => _count = v);
                                    _emit();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _intervalLabel(
    AppLocalizations l10n,
    Frequency f,
    int interval,
  ) {
    final n = interval;
    switch (f) {
      case Frequency.daily:
        return l10n.intervalDays(n);
      case Frequency.weekly:
        return l10n.intervalWeeks(n);
      case Frequency.monthly:
        return l10n.intervalMonths(n);
      case Frequency.yearly:
        return l10n.intervalYears(n);
      default:
        return '';
    }
  }
}

class _WeekdayChips extends StatelessWidget {
  const _WeekdayChips({
    required this.l10n,
    required this.selected,
    required this.onToggle,
  });

  final AppLocalizations l10n;

  final Set<ByWeekDayEntry> selected;
  final ValueChanged<ByWeekDayEntry> onToggle;

  List<(ByWeekDayEntry, String)> get days => [
    (ByWeekDayEntry(1), l10n.weekdayMonShort),
    (ByWeekDayEntry(2), l10n.weekdayTueShort),
    (ByWeekDayEntry(3), l10n.weekdayWedShort),
    (ByWeekDayEntry(4), l10n.weekdayThuShort),
    (ByWeekDayEntry(5), l10n.weekdayFriShort),
    (ByWeekDayEntry(6), l10n.weekdaySatShort),
    (ByWeekDayEntry(7), l10n.weekdaySunShort),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((d) {
        final on = selected.contains(d.$1);
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => onToggle(d.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: on
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.10)
                  : Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: on
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.55)
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.15),
                width: 1.2,
              ),
            ),
            child: Text(
              d.$2,
              style: TextStyle(
                color: on ? Theme.of(context).colorScheme.primary : Colors.grey,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _EndModeRow extends StatelessWidget {
  const _EndModeRow({
    required this.l10n,
    required this.mode,
    required this.onChanged,
  });
  final AppLocalizations l10n;
  final _EndMode mode;
  final ValueChanged<_EndMode> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget chip(_EndMode m, String label) {
      final sel = mode == m;
      return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onChanged(m),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: sel
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.10)
                : Colors.white.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: sel
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.55)
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.15),
              width: 1.2,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: sel ? Theme.of(context).colorScheme.primary : Colors.grey,
              fontWeight: FontWeight.w900,
              fontSize: 10,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        if (MediaQuery.of(context).size.width > 600) ...[
          Text(l10n.ends),
          const Spacer(),
        ],
        Wrap(
          spacing: 5,
          children: [
            chip(_EndMode.never, l10n.never),
            chip(_EndMode.until, l10n.until),
            chip(_EndMode.count, l10n.count),
          ],
        ),
      ],
    );
  }
}
