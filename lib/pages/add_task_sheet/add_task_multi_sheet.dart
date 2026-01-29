import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:rrule/rrule.dart';
import 'package:timecraft/components/add_subtasks_field.dart';
import 'package:timecraft/components/date_time_field.dart';
import 'package:timecraft/components/priority_field.dart';
import 'package:timecraft/components/rrule_picker.dart';
import 'package:timecraft/components/task_input_field.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/system_design/tc_button.dart';
import 'package:timecraft/system_design/tc_fext_field.dart';
import 'package:timecraft/system_design/tc_input_decorator.dart';
import 'package:timecraft/system_design/tc_radio_button.dart';

class AddTaskSheetMultiStep extends StatefulWidget {
  const AddTaskSheetMultiStep({
    super.key,
    this.initialStart,
    this.initialEnd,
    this.initialPattern,
  });

  final DateTime? initialStart;
  final DateTime? initialEnd;
  final TaskPattern? initialPattern;

  static Future<TaskPattern?> show(
    BuildContext context, {
    DateTime? initialStart,
    DateTime? initialEnd,
    TaskPattern? initialPattern,
  }) async {
    return await showModalBottomSheet<TaskPattern>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTaskSheetMultiStep(
        initialStart: initialStart,
        initialEnd: initialEnd,
        initialPattern: initialPattern,
      ),
    );
  }

  @override
  State<AddTaskSheetMultiStep> createState() => _AddTaskSheetMultiStepState();
}

class _AddTaskSheetMultiStepState extends State<AddTaskSheetMultiStep> {
  static const bgCard = Color(0xFFF6F7FB);
  static const stroke = Color(0xFFB9BFCC);
  int _step = 0;

  String _raw = '';
  String _title = '';
  List<String> _tags = [];

  final TextEditingController _descCtrl = TextEditingController();

  int _priority = 3;

  final List<String> _subtasks = [];

  DateTime? _startLocal;
  DateTime? _endLocal;

  bool repeating = false;

  RecurrenceRule? _rrule;

  _CompletionMode _completionMode = _CompletionMode.binary;

  final _targetCtrl = TextEditingController(text: '10');
  final _unitCtrl = TextEditingController();
  bool _unitInitialized = false;

  @override
  void initState() {
    super.initState();
    _startLocal = widget.initialPattern?.startTime ?? widget.initialStart;
    _endLocal = widget.initialPattern?.endTime ?? widget.initialEnd;
    if (widget.initialPattern != null) {
      final pattern = widget.initialPattern!;
      _raw = '${pattern.title} ${pattern.tags.map((e) => '#$e').join(' ')}';
      _title = pattern.title;
      _tags = pattern.tags;
      _descCtrl.text = pattern.description;
      _priority = pattern.priority;
      _subtasks.addAll(pattern.subTasks);
      if (pattern.rrule != null) {
        repeating = true;
        _rrule = pattern.rrule;
      }
      if (pattern.completion is BinaryCompletion) {
        _completionMode = _CompletionMode.binary;
      } else if (pattern.completion is QuantityCompletion) {
        _completionMode = _CompletionMode.quantitative;
        final qc = pattern.completion as QuantityCompletion;
        _targetCtrl.text = qc.cap.toString();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_unitInitialized) return;
    final l10n = AppLocalizations.of(context)!;
    if (_unitCtrl.text.isEmpty) {
      _unitCtrl.text = l10n.defaultUnit;
    }
    _unitInitialized = true;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _targetCtrl.dispose();
    _unitCtrl.dispose();
    super.dispose();
  }

  bool _validateStep(int step) {
    final l10n = AppLocalizations.of(context)!;
    if (step == 0) {
      if (_title.isEmpty) {
        _toast(l10n.validationTitleRequired);
        return false;
      }
      return true;
    }
    if (step == 1) {
      if (_startLocal != null &&
          _endLocal != null &&
          !_endLocal!.isAfter(_startLocal!)) {
        _toast(l10n.validationEndAfterStart);
        return false;
      }
      return true;
    }
    return true;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _next() {
    if (!_validateStep(_step)) return;
    if (_step < 2) setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Completion _buildCompletion() {
    if (_completionMode == _CompletionMode.binary) {
      return BinaryCompletion(false);
    } else if (_completionMode == _CompletionMode.quantitative) {
      final target = int.tryParse(_targetCtrl.text.trim()) ?? 10;
      return QuantityCompletion(target, 0);
    }
    return BinaryCompletion(false);
  }

  void _submit() {
    if (!_validateStep(0) || !_validateStep(1) || !_validateStep(2)) return;

    final completion = _buildCompletion();

    final id =
        widget.initialPattern?.id ?? DateTime.now().millisecondsSinceEpoch;

    final task = TaskPattern(
      id: id.toString(),
      title: _title,
      completion: completion,
      description: _descCtrl.text.trim(),
      startTime: _startLocal,
      duration: _startLocal != null && _endLocal != null
          ? _endLocal!.difference(_startLocal!)
          : null,
      rrule: repeating ? _rrule : null,
      tags: _tags,
      priority: _priority,
      reminders: const [],
      subTasks: List.of(_subtasks),
    );

    //widget.onSubmit(task);
    Navigator.of(context).maybePop(task);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          decoration: BoxDecoration(
            color: bgCard.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: stroke.withValues(alpha: 0.95),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: Colors.black.withValues(alpha: 0.10),
              ),
            ],
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.62,
            minChildSize: 0.35,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.createTask,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (widget.initialPattern != null)
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              Navigator.of(context).maybePop<TaskPattern>(
                                widget.initialPattern!.copyWith(deleted: true),
                              );
                            },
                          ),
                        IconButton(
                          onPressed: () =>
                              Navigator.of(context).maybePop<TaskPattern>(null),
                          icon: const Icon(Icons.close, color: Colors.black),
                          splashRadius: 22,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _StepHeader(step: _step),

                    const SizedBox(height: 12),

                    Flexible(
                      child: ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: _buildStepBody(_step),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: TcButton(
                                  outlined: true,
                                  onTap: _step == 0
                                      ? () => Navigator.of(
                                          context,
                                        ).maybePop<TaskPattern>(null)
                                      : _back,
                                  child: Text(
                                    _step == 0 ? l10n.cancel : l10n.back,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TcButton(
                                  onTap: _step == 2 ? _submit : _next,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _step == 2
                                            ? Icons.check_rounded
                                            : Icons.arrow_forward_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _step == 2 ? l10n.create : l10n.next,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepBody(int step) {
    switch (step) {
      case 0:
        return _StepBasics(
          //key: const ValueKey('step0'),
          initialTitle: _raw,
          descCtrl: _descCtrl,
          onTitleChanged: (parsed) {
            setState(() {
              _raw = parsed.$1;
              _title = parsed.$2;
              _tags = parsed.$3;
            });
          },
          priority: _priority,
          onPriorityChanged: (v) => setState(() => _priority = v),
          onSubtasksChanged: (subs) => setState(
            () => _subtasks
              ..clear()
              ..addAll(subs),
          ),
          subtasks: _subtasks,
        );

      case 1:
        return _StepSchedule(
          //key: const ValueKey('step1'),
          startLocal: _startLocal,
          endLocal: _endLocal,
          onPickStart: (t) => setState(() => _startLocal = t),
          onPickEnd: (t) => setState(() => _endLocal = t),
          repeating: repeating,
          onRepeatingChanged: (r) => setState(() => repeating = r),
          rruleNotifier: (r) => setState(() {
            _rrule = r;
          }),
          rrule: _rrule,
        );

      case 2:
        return _StepCompletion(
          //key: const ValueKey('step2'),
          mode: _completionMode,
          onModeChanged: (m) => setState(() => _completionMode = m),
          targetCtrl: _targetCtrl,
          unitCtrl: _unitCtrl,
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    Widget chip(int idx, String label) {
      final active = idx == step;
      final done = idx < step;
      final color = active
          ? Colors.black
          : Colors.black.withValues(alpha: 0.85);
      final bg = active
          ? Colors.black.withValues(alpha: 0.10)
          : Colors.white.withValues(alpha: 0.55);

      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: active ? 0.65 : 0.85),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (done)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: Colors.black,
                  )
                else
                  Icon(
                    active
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 16,
                    color: active
                        ? Colors.black
                        : Colors.black.withValues(alpha: 0.55),
                  ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: active
                        ? Colors.black
                        : Colors.black.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip(0, AppLocalizations.of(context)!.basics),
        const SizedBox(width: 8),
        chip(1, AppLocalizations.of(context)!.schedule),
        const SizedBox(width: 8),
        chip(2, AppLocalizations.of(context)!.completion),
      ],
    );
  }
}

class _StepBasics extends StatelessWidget {
  const _StepBasics({
    this.initialTitle,
    required this.descCtrl,

    required this.onTitleChanged,

    required this.priority,
    required this.onPriorityChanged,

    required this.subtasks,
    required this.onSubtasksChanged,
  });
  final String? initialTitle;
  final TextEditingController descCtrl;
  final ValueChanged<(String raw, String title, List<String> tags)>
  onTitleChanged;

  final int priority;
  final ValueChanged<int> onPriorityChanged;

  final List<String> subtasks;
  final ValueChanged<List<String>> onSubtasksChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      children: [
        TaskInputAdvancedField(
          initialText: initialTitle ?? '',
          availableTags: ['test', 'test2', 'test3', 'test4', 'test5'],
          onChanged: (parsed) {
            onTitleChanged((parsed.raw, parsed.title, parsed.tags));
          },
        ),
        const SizedBox(height: 12),
        TcTextField(
          controller: descCtrl,
          maxLines: 3,
          labelText: AppLocalizations.of(context)!.description,
          leading: const Icon(Icons.description_outlined),
        ),
        const SizedBox(height: 12),
        PriorityField(value: priority, onChanged: onPriorityChanged),
        const SizedBox(height: 12),

        // Subtasks
        AddSubtasksField(
          onChanged: onSubtasksChanged,
          initialSubtasks: subtasks,
        ),
      ],
    );
  }
}

class _StepSchedule extends StatelessWidget {
  const _StepSchedule({
    required this.startLocal,
    required this.endLocal,
    required this.onPickStart,
    required this.onPickEnd,

    required this.repeating,
    required this.onRepeatingChanged,

    required this.rrule,
    required this.rruleNotifier,
  });

  final DateTime? startLocal;
  final DateTime? endLocal;

  final ValueChanged<DateTime?> onPickStart;
  final ValueChanged<DateTime?> onPickEnd;

  final bool repeating;
  final ValueChanged<bool> onRepeatingChanged;

  final RecurrenceRule? rrule;
  final ValueChanged<RecurrenceRule?> rruleNotifier;

  @override
  Widget build(BuildContext context) {
    final baseStart = startLocal ?? DateTime.now();

    return Column(
      key: key,
      children: [
        Row(
          children: [
            Expanded(
              child: DateTimeField(
                label: AppLocalizations.of(context)!.start,
                value: startLocal,
                onPick: onPickStart,
                onClear: () => onPickStart(null),
              ),
            ),
            const SizedBox(height: 12, width: 12),
            Expanded(
              child: DateTimeField(
                label: AppLocalizations.of(context)!.end,
                value: endLocal,
                onPick: onPickEnd,
                onClear: () => onPickEnd(null),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(Icons.repeat_rounded),
              onPressed: () {
                if (startLocal != null && endLocal != null) {
                  onRepeatingChanged(!repeating);
                }
              },
              isSelected: repeating,
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (repeating)
          RRulePicker(
            initialStartLocal: baseStart,
            initialRrule: rrule,
            onChanged: (r) {
              rruleNotifier(r);
            },
          ),
      ],
    );
  }
}

enum _CompletionMode { binary, quantitative }

class _StepCompletion extends StatelessWidget {
  const _StepCompletion({
    required this.mode,
    required this.onModeChanged,
    required this.targetCtrl,
    required this.unitCtrl,
  });

  final _CompletionMode mode;
  final ValueChanged<_CompletionMode> onModeChanged;

  final TextEditingController targetCtrl;
  final TextEditingController unitCtrl;

  @override
  Widget build(BuildContext context) {
    return TcInputDecorator(
      labelText: AppLocalizations.of(context)!.completion,
      prefixIcon: const Icon(Icons.verified_outlined),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ModeSegment(mode: mode, onChanged: onModeChanged),
          const SizedBox(height: 12),

          if (mode == _CompletionMode.quantitative)
            _QuantCompletionForm(targetCtrl: targetCtrl, unitCtrl: unitCtrl),
        ],
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({required this.mode, required this.onChanged});
  final _CompletionMode mode;
  final ValueChanged<_CompletionMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TcRadioButton(
            selected: mode == _CompletionMode.binary,
            onTap: () => onChanged(_CompletionMode.binary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: 18,
                  color: mode == _CompletionMode.binary
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black.withValues(alpha: 0.55),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.yesNo,
                  style: TextStyle(
                    color: mode == _CompletionMode.binary
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TcRadioButton(
            selected: mode == _CompletionMode.quantitative,
            onTap: () => onChanged(_CompletionMode.quantitative),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.format_list_numbered_rounded,
                  size: 18,
                  color: mode == _CompletionMode.quantitative
                      ? Theme.of(context).colorScheme.primary
                      : Colors.black.withValues(alpha: 0.55),
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.quantity,
                  style: TextStyle(
                    color: mode == _CompletionMode.quantitative
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuantCompletionForm extends StatelessWidget {
  const _QuantCompletionForm({
    required this.targetCtrl,
    required this.unitCtrl,
  });

  final TextEditingController targetCtrl;
  final TextEditingController unitCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TcTextField(
                controller: targetCtrl,
                labelText: AppLocalizations.of(context)!.target,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TcTextField(
                controller: unitCtrl,
                labelText: AppLocalizations.of(context)!.unit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
