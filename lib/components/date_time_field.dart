import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/system_design/tc_input_decorator.dart';

class DateTimeField extends StatelessWidget {
  const DateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onPick,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final void Function(DateTime?) onPick;
  final VoidCallback onClear;

  String timeToString(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = value != null ? timeToString(value!) : l10n.dateTimeNotSet;
    return InkWell(
      onTap: () {
        _pickDateTime(context, initial: value).then((dt) {
          onPick(dt);
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: TcInputDecorator(
        labelText: label,
        suffixIcon: value != null
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: onClear,
              )
            : null,
        prefixIcon: const Icon(Icons.schedule_outlined),

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
}
