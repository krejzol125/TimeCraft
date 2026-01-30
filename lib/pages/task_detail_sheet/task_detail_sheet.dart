import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/components/scope_dialog.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/pages/add_task_sheet/add_task_multi_sheet.dart';
import 'package:timecraft/repo/task_repo.dart';
import 'package:timecraft/system_design/tc_button.dart';
import 'package:timecraft/system_design/tc_stepper.dart';

class TaskDetailsSheet extends StatefulWidget {
  const TaskDetailsSheet({super.key, required this.task, required this.repo});

  final TaskInstance task;
  final TaskRepo repo;

  static Future<void> show(
    BuildContext context, {
    required TaskInstance task,
    required TaskRepo repo,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return TaskDetailsSheet(task: task, repo: repo);
      },
    );
  }

  @override
  State<TaskDetailsSheet> createState() => _TaskDetailsSheetState();
}

class _TaskDetailsSheetState extends State<TaskDetailsSheet> {
  static const bgCard = Color(0xFFF6F7FB);
  static const stroke = Color(0xFFB9BFCC);
  static const text = Color(0xFF111827);
  static const subtext = Color(0xFF6B7280);
  static const accent = Color(0xFF1F4AA8);

  late TaskInstance _task;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  String _fmtHm(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _fmtDate(DateTime dt) => '${dt.day}.${dt.month}.${dt.year}';

  Completion _toggleCompletion(Completion c, int value) {
    c.mark(value);
    return c;
  }

  int _priorityToStars(int p) => p.clamp(1, 5);

  Future<void> _setCompleted(int value) async {
    setState(() => _saving = true);
    try {
      if (_task.rid == null) {
        TaskPattern? pattern = await widget.repo.getPatternById(_task.taskId);
        if (pattern == null) return;
        widget.repo.upsertPattern(
          pattern.copyWith(
            completion: _toggleCompletion(pattern.completion, value),
          ),
        );
        return;
      }
      TaskOverride override = TaskOverride(
        taskId: _task.taskId,
        rid: _task.rid!,
        completion: _toggleCompletion(_task.completion, value),
      );
      await widget.repo.overrideTask(override);
      if (!mounted) return;
      setState(() => _task = _task.copyWith(completion: override.completion));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _onEdit() async {
    final pattern = await widget.repo.getPatternById(_task.taskId);
    if (pattern == null) return;
    RecurrenceMoveScope? scope;
    if (pattern.rrule == null || _task.rid == null) {
      scope = RecurrenceMoveScope.entireSeries;
    } else if (mounted) {
      scope = await showMoveScopeDialog(context);
    }

    if (scope == null) return;
    switch (scope) {
      case RecurrenceMoveScope.singleOccurrence:
        if (mounted == false) return;
        final updated = await AddTaskSheetMultiStep.show(
          context,
          initialPattern: pattern.copyWith(
            startTime: _task.startTime,
            duration: _task.duration,
            rrule: null,
          ),
        );
        if (updated == null) return;
        if (_task.rid == null) {
          widget.repo.upsertPattern(updated);
        } else {
          final taskOverride = updated.differenceFrom(pattern, _task.rid!);
          await widget.repo.overrideTask(taskOverride);
        }
        break;
      case RecurrenceMoveScope.entireSeries:
        if (mounted == false) return;
        final updated = await AddTaskSheetMultiStep.show(
          context,
          initialPattern: pattern,
        );
        if (updated == null) return;
        widget.repo.upsertPattern(updated);
        break;
      case RecurrenceMoveScope.thisAndFuture:
        if (mounted == false) return;
        final updated = await AddTaskSheetMultiStep.show(
          context,
          initialPattern: pattern.copyWith(
            startTime: _task.startTime,
            duration: _task.duration,
          ),
        );
        if (updated == null) return;
        widget.repo.splitPattern(_task.taskId, _task.rid!, updated);
        break;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final start = _task.startTime;
    final end = _task.endTime;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        decoration: BoxDecoration(
          color: bgCard.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: stroke.withValues(alpha: 0.95), width: 1.2),
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
          maxChildSize: 0.92,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PriorityBadge(stars: _priorityToStars(_task.priority)),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _task.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: text,
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (start != null && end != null)
                              _InfoLine(
                                icon: Icons.schedule_rounded,
                                text:
                                    '${_fmtDate(start)} • ${_fmtHm(start)}–${_fmtHm(end)}',
                              )
                            else
                              _InfoLine(
                                icon: Icons.schedule_rounded,
                                text: l10n.unscheduled,
                              ),
                            const SizedBox(height: 6),
                            if (_task.tags.isNotEmpty)
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: _task.tags
                                    .map((t) => _TagPill(label: '#$t'))
                                    .toList(),
                              ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: subtext,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(height: 1),

                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    children: [
                      _Card(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: _task.completion.isCompleted
                                  ? accent
                                  : subtext,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l10n.completed,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: text,
                                ),
                              ),
                            ),
                            if (_saving)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            else if (_task.completion is BinaryCompletion) ...[
                              Switch(
                                value: _task.completion.isCompleted,
                                onChanged: (comp) async {
                                  await _setCompleted(comp ? 1 : 0);
                                },
                              ),
                            ] else if (_task.completion
                                is QuantityCompletion) ...[
                              TcStepper(
                                value: (_task.completion as QuantityCompletion)
                                    .comp,
                                onChanged: (comp) async {
                                  await _setCompleted(comp);
                                },
                                min: 0,
                                max: (_task.completion as QuantityCompletion)
                                    .cap,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '/${(_task.completion as QuantityCompletion).cap}',
                                style: const TextStyle(
                                  color: subtext,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      if (_task.description.trim().isNotEmpty)
                        _Card(
                          title: l10n.description,
                          child: Text(
                            _task.description,
                            style: const TextStyle(
                              color: text,
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          ),
                        ),

                      if (_task.description.trim().isNotEmpty)
                        const SizedBox(height: 10),

                      if (_task.subTasks.isNotEmpty)
                        _Card(
                          title: l10n.subtasks,
                          child: Column(
                            children: [
                              for (final st in _task.subTasks)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        st.$2
                                            ? Icons.check_box_rounded
                                            : Icons
                                                  .check_box_outline_blank_rounded,
                                        color: st.$2 ? accent : subtext,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          st.$1,
                                          style: TextStyle(
                                            color: text,
                                            fontWeight: FontWeight.w700,
                                            decoration: st.$2
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                      if (_task.subTasks.isNotEmpty) const SizedBox(height: 10),

                      _Card(
                        title: l10n.details,
                        child: Column(
                          children: [
                            _DataRow(
                              label: l10n.priority,
                              value: '${_task.priority}/5',
                              icon: Icons.bolt_rounded,
                            ),
                            const SizedBox(height: 6),
                            _DataRow(
                              label: l10n.reminders,
                              value: '${_task.reminders.length}',
                              icon: Icons.notifications_active_rounded,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: TcButton(
                              icon: Icons.edit_rounded,
                              label: l10n.edit,
                              onTap: _onEdit,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TcButton(
                              primary: false,
                              icon: Icons.close_rounded,
                              label: l10n.close,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.title});

  final String? title;
  final Widget child;

  static const stroke = _TaskDetailsSheetState.stroke;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke.withValues(alpha: 0.85)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: _TaskDetailsSheetState.text,
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _TaskDetailsSheetState.subtext),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _TaskDetailsSheetState.subtext,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _TaskDetailsSheetState.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _TaskDetailsSheetState.accent.withValues(alpha: 0.30),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _TaskDetailsSheetState.accent,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _TaskDetailsSheetState.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _TaskDetailsSheetState.accent.withValues(alpha: 0.35),
        ),
      ),
      child: Center(
        child: Text(
          'P$stars',
          style: const TextStyle(
            color: _TaskDetailsSheetState.accent,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _TaskDetailsSheetState.subtext),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: _TaskDetailsSheetState.subtext,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _TaskDetailsSheetState.text,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// class _PrimaryButton extends StatelessWidget {
//   const _PrimaryButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: _TaskDetailsSheetState.accent.withValues(alpha: 0.12),
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: _TaskDetailsSheetState.accent.withValues(alpha: 0.35),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: _TaskDetailsSheetState.accent),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: _TaskDetailsSheetState.accent,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SecondaryButton extends StatelessWidget {
//   const _SecondaryButton({
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white.withValues(alpha: 0.55),
//       borderRadius: BorderRadius.circular(16),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(16),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: _TaskDetailsSheetState.stroke.withValues(alpha: 0.85),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: _TaskDetailsSheetState.subtext),
//               const SizedBox(width: 8),
//               Text(
//                 label,
//                 style: const TextStyle(
//                   color: _TaskDetailsSheetState.subtext,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
