import 'package:flutter/material.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/task_input_field.dart';
// import 'package:timecraft/model/noti_reminder.dart'; // jeśli użyjesz przypomnień

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key, required this.onSubmit});
  final void Function(TaskInstance task) onSubmit;

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();

  DateTime? _start;
  DateTime? _end;
  int _priority = 3;

  // dynamiczne subtaski
  final List<TextEditingController> _subtaskCtrls = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _tagsCtrl.dispose();
    for (final c in _subtaskCtrls) {
      c.dispose();
    }
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
      context: context,
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

    final id = DateTime.now().millisecondsSinceEpoch;
    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final subTasks = _subtaskCtrls
        .map<(String, bool)>((c) => (c.text.trim(), false))
        .where((t) => t.$1.isNotEmpty)
        .toList();

    final task = TaskInstance(
      id: id,
      title: _titleCtrl.text.trim(),
      completion: BinaryCompletion(false),
      description: _descCtrl.text.trim(),
      startTime: _start,
      endTime: _end,
      tags: tags,
      priority: _priority,
      reminders: const [], // tutaj możesz dołożyć UI dla przypomnień
      subTasks: subTasks,
    );

    widget.onSubmit(task);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets; // dla klawiatury

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
                  // nagłówek
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

                  // title
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
                    initialText: _titleCtrl.text,
                    availableTags: ['test', 'test2'],
                    onChanged: (parsed) {
                      _titleCtrl.text = parsed.title;
                      _tagsCtrl.text = parsed.tags.join(', ');
                    },
                  ),
                  const SizedBox(height: 12),

                  // description
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.notes),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Start / End
                  Row(
                    children: [
                      Expanded(
                        child: _DateTimeField(
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
                        child: _DateTimeField(
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

                  // Priority
                  Row(
                    children: [
                      const Icon(Icons.flag_outlined, size: 20),
                      const SizedBox(width: 8),
                      const Text('Priority'),
                      const Spacer(),
                      DropdownButton<int>(
                        value: _priority,
                        onChanged: (v) => setState(() => _priority = v ?? 3),
                        items: List.generate(5, (i) => i + 1)
                            .map(
                              (p) => DropdownMenuItem(
                                value: p,
                                child: Text(p.toString()),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tags
                  TextFormField(
                    controller: _tagsCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma-separated)',
                      prefixIcon: Icon(Icons.sell_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtasks
                  Row(
                    children: [
                      const Icon(Icons.checklist_outlined, size: 20),
                      const SizedBox(width: 8),
                      const Text('Subtasks'),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          setState(
                            () => _subtaskCtrls.add(TextEditingController()),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                  ...List.generate(_subtaskCtrls.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _subtaskCtrls[i],
                              decoration: InputDecoration(
                                hintText: 'Subtask ${i + 1}',
                                prefixIcon: const Icon(
                                  Icons.subdirectory_arrow_right,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: 'Remove',
                            onPressed: () {
                              final c = _subtaskCtrls.removeAt(i);
                              c.dispose();
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Create'),
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

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onPick;
  final VoidCallback onClear;

  String _fmt(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final text = value != null ? _fmt(value!) : 'Not set';
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.schedule_outlined),
          suffixIcon: value != null
              ? IconButton(
                  tooltip: 'Clear',
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            text,
            style: TextStyle(
              color: value != null ? Colors.black87 : Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}
