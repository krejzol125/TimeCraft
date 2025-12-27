import 'package:flutter/material.dart';
import 'package:timecraft/components/add_subtasks_field.dart';
import 'package:timecraft/components/date_time_field.dart';
import 'package:timecraft/components/priority_field.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/components/task_input_field.dart';
import 'package:timecraft/system_design/tc_button.dart';
import 'package:timecraft/system_design/tc_fext_field.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key, required this.onSubmit});
  final void Function(TaskInstance task) onSubmit;

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

  Future<DateTime?> _pickDateTime(
    BuildContext context, {
    DateTime? initial,
  }) async {
    final now = DateTime.now();
    final base = initial ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: mounted
          ? context
          : throw Exception(
              'context nie jest mounted cokolwiek to znaczy nwm lint krzyczał',
            ),
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
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

    final subTasks = _subtasks
        .map<(String, bool)>((c) => (c.trim(), false))
        .where((t) => t.$1.isNotEmpty)
        .toList();

    final task = TaskInstance(
      id: id,
      title: _title.trim(),
      completion: BinaryCompletion(false),
      description: _descCtrl.text.trim(),
      startTime: _start,
      endTime: _end,
      tags: tags,
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

                  //title
                  // TextFormField(
                  //   controller: _titleCtrl,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Title *',
                  //     prefixIcon: Icon(Icons.title),
                  //   ),
                  //   textInputAction: TextInputAction.next,
                  //   validator: (v) {
                  //     if (v == null || v.trim().isEmpty)
                  //       return 'Title is required';
                  //     if (v.trim().length < 2) return 'Title is too short';
                  //     return null;
                  //   },
                  // ),
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
                          onPick: () async {
                            final dt = await _pickDateTime(
                              context,
                              initial: _start ?? DateTime.now(),
                            );
                            if (dt != null) setState(() => _start = dt);
                          },
                          onClear: () => setState(() => _start = null),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DateTimeField(
                          label: 'End',
                          value: _end,
                          onPick: () async {
                            final base = _start ?? DateTime.now();
                            final dt = await _pickDateTime(
                              context,
                              initial: _end ?? base,
                            );
                            if (dt != null) setState(() => _end = dt);
                          },
                          onClear: () => setState(() => _end = null),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  //TODO: make it dots/radio
                  PriorityField(
                    value: _priority,
                    onChanged: (int p) {
                      setState(() {
                        _priority = p;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // TextFormField(
                  //   controller: _tagsCtrl,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Tags',
                  //     prefixIcon: Icon(Icons.sell_outlined),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),

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
