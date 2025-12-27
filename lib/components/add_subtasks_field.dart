import 'package:flutter/material.dart';
import 'package:timecraft/system_design/tc_button.dart';
import 'package:timecraft/system_design/tc_fext_field.dart';

class AddSubtasksField extends StatefulWidget {
  const AddSubtasksField({
    super.key,
    required this.onChanged,
    this.initialSubtasks = const [],
  });

  final void Function(List<String> subtasks) onChanged;
  final List<String> initialSubtasks;

  @override
  State<AddSubtasksField> createState() => _AddSubtasksFieldState();
}

class _AddSubtasksFieldState extends State<AddSubtasksField> {
  final List<TextEditingController> _subtaskCtrls = [];
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Subtasks',
        prefixIcon: const Icon(Icons.checklist_outlined),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(_subtaskCtrls.length, (i) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: TcTextField(
                controller: _subtaskCtrls[i],
                onChanged: (s) =>
                    widget.onChanged(_subtaskCtrls.map((c) => c.text).toList()),
                hintText: 'Subtask ${i + 1}',
                leading: const Icon(Icons.subdirectory_arrow_right),
                trailing: IconButton(
                  tooltip: 'Remove',
                  onPressed: () {
                    final c = _subtaskCtrls.removeAt(i);
                    widget.onChanged(_subtaskCtrls.map((c) => c.text).toList());
                    c.dispose();
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: TcButton(
              onTap: () {
                _subtaskCtrls.add(TextEditingController());
                widget.onChanged(_subtaskCtrls.map((c) => c.text).toList());
                setState(() {});
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Add Subtask',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(bottom: 8),
    //   child: Row(
    //     children: [
    //       Expanded(
    //         child: TextField(
    //           controller: _subtaskCtrls[i],
    //           onChanged: (s) => widget.onChanged(
    //             _subtaskCtrls.map((c) => c.text).toList(),
    //           ),
    //           decoration: InputDecoration(
    //             hintText: 'Subtask ${i + 1}',
    //             prefixIcon: const Icon(Icons.subdirectory_arrow_right),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(width: 8),
    //       IconButton(
    //         tooltip: 'Remove',
    //         onPressed: () {
    //           final c = _subtaskCtrls.removeAt(i);
    //           widget.onChanged(
    //             _subtaskCtrls.map((c) => c.text).toList(),
    //           );
    //           c.dispose();
    //           setState(() {});
    //         },
    //         icon: const Icon(Icons.delete_outline),
    //       ),
    //     ],
    //   ),
    // );
  }
}
