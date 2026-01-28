import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:timecraft/components/add_subtasks_field.dart';
import 'package:timecraft/components/date_time_field.dart';
import 'package:timecraft/components/priority_field.dart';
import 'package:timecraft/components/rrule_picker.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/components/task_input_field.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/system_design/tc_button.dart';
import 'package:timecraft/system_design/tc_fext_field.dart';
import 'package:timecraft/system_design/tc_icon_button.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key, required this.onSubmit});
  final void Function(TaskPattern task) onSubmit;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  final _descCtrl = TextEditingController();
  List<String> _tags = [];

  DateTime? _start;
  DateTime? _end;
  bool repeating = false;
  RecurrenceRule? _rrule;
  int _priority = 2;

  //final List<TextEditingController> _subtaskCtrls = [];
  final List<String> _subtasks = [];

  @override
  void dispose() {
    _descCtrl.dispose();
    // for (final c in _subtaskCtrls) {
    //   c.dispose();
    // }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_start != null && _end != null && !_end!.isAfter(_start!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }
    if ((_end != null && _start == null) || (_end == null && _start != null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both start and end time must be set together'),
        ),
      );
      return;
    }

    if (_title.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }
    if (_title.trim().length < 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title is too short')));
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch;
    final tags = _tags.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    final subTasks = _subtasks.where((t) => t.isNotEmpty).toList();

    final task = TaskPattern(
      id: id.toString(),
      title: _title.trim(),
      completion: BinaryCompletion(false),
      description: _descCtrl.text.trim(),
      startTime: _start,
      duration: _start != null && _end != null
          ? _end!.difference(_start!)
          : null,
      tags: tags,
      rrule: _rrule,
      priority: _priority,
      reminders: const [],
      subTasks: subTasks,
    );

    widget.onSubmit(task);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Create Task',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  TaskInputAdvancedField(
                    initialText: _title,
                    availableTags: ['test', 'test2'],
                    onChanged: (parsed) {
                      _title = parsed.title;
                      _tags = parsed.tags;
                    },
                  ),
                  const SizedBox(height: 12),

                  // description
                  TcTextField(
                    controller: _descCtrl,
                    maxLines: 3,
                    labelText: 'Description',
                    leading: const Icon(Icons.description_outlined),
                  ),
                  const SizedBox(height: 12),

                  // Start / End
                  Row(
                    children: [
                      Expanded(
                        child: DateTimeField(
                          label: 'Start',
                          value: _start,
                          onPick: (dt) => setState(() {
                            _start = dt;
                          }),
                          onClear: () => setState(() {
                            _start = null;
                            repeating = false;
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.arrow_forward),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DateTimeField(
                          label: 'End',
                          value: _end,
                          onPick: (dt) => setState(() {
                            _end = dt;
                          }),
                          onClear: () => setState(() {
                            _end = null;
                            repeating = false;
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.repeat_rounded),
                        onPressed: () {
                          if (_start != null && _end != null) {
                            setState(() {
                              repeating = !repeating;
                            });
                          }
                        },
                        isSelected: repeating,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // RRule
                  if (repeating) ...[
                    RRulePicker(
                      initialStartLocal: _start ?? DateTime.now(),
                      initialRrule: _rrule,
                      onChanged: (v) {
                        _rrule = v;
                      },
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Priority
                  PriorityField(
                    value: _priority,
                    onChanged: (int p) {
                      setState(() {
                        _priority = p;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Subtasks
                  AddSubtasksField(
                    onChanged: (subs) {
                      setState(() {
                        _subtasks.clear();
                        _subtasks.addAll(subs);
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: TcButton(
                          outlined: true,
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TcButton(
                          onTap: _submit,
                          child: Text(
                            'Create Task',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
