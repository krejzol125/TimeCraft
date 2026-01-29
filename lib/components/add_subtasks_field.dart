import 'package:flutter/material.dart';
import 'package:timecraft/system_design/tc_fext_field.dart';
import 'package:timecraft/system_design/tc_input_decorator.dart';

class AddSubtasksField extends StatefulWidget {
  const AddSubtasksField({
    super.key,
    required this.onChanged,
    this.initialSubtasks = const [],
  });

  final void Function(List<String> subtasks) onChanged;
  final List<String> initialSubtasks;

  @override
  State<AddSubtasksField> createState() =>
      _AddSubtasksFieldState(initialSubtasks);
}

class _AddSubtasksFieldState extends State<AddSubtasksField> {
  _AddSubtasksFieldState(List<String> initialSubtasks) {
    _subtasks = List.from(initialSubtasks);
  }
  late List<String> _subtasks;
  late TextEditingController _subtaskCtrls;

  @override
  void initState() {
    super.initState();
    _subtaskCtrls = TextEditingController();
  }

  void addSubtask(String name) {
    setState(() {
      _subtasks.add(name);
    });
    widget.onChanged(_subtasks);
  }

  @override
  Widget build(BuildContext context) {
    return TcInputDecorator(
      labelText: 'Subtasks',
      prefixIcon: const Icon(Icons.checklist_outlined),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TcTextField(
            controller: _subtaskCtrls,
            hintText: 'Add subtask...',
            leading: IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: 'Add subtask',
              onPressed: () {
                addSubtask(_subtaskCtrls.text);
                _subtaskCtrls.clear();
              },
            ),
          ),
          ...List.generate(_subtasks.length, (i) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: _SubtaskRow(
                name: _subtasks[i],
                onRemove: () {
                  _subtasks.removeAt(i);
                  widget.onChanged(_subtasks);
                  setState(() {}); // Refresh UI
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SubtaskRow extends StatelessWidget {
  const _SubtaskRow({required this.name, required this.onRemove});

  final String name;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TcInputDecorator(
        labelText: '',
        prefixIcon: Icon(
          Icons.subdirectory_arrow_right_rounded,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: IconButton(
          onPressed: onRemove,
          icon: Icon(
            Icons.close_rounded,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.9),
          ),
          splashRadius: 18,
        ),
        child: Text(
          name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
