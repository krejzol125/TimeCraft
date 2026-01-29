import 'package:flutter/material.dart';

enum RecurrenceMoveScope { singleOccurrence, thisAndFuture, entireSeries }

Future<RecurrenceMoveScope?> showMoveScopeDialog(BuildContext context) {
  return showModalBottomSheet<RecurrenceMoveScope>(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7FB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFB9BFCC), width: 1.2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.repeat_rounded, color: Color(0xFF111827)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Move recurring task',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'What do you want to move?',
              style: TextStyle(
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            _ScopeOption(
              icon: Icons.looks_one_rounded,
              title: 'Only this occurrence',
              subtitle: 'Move just the one you dragged.',
              onTap: () =>
                  Navigator.of(ctx).pop(RecurrenceMoveScope.singleOccurrence),
            ),
            const SizedBox(height: 8),
            _ScopeOption(
              icon: Icons.forward_rounded,
              title: 'This and future',
              subtitle: 'Move this occurrence and all after it.',
              onTap: () =>
                  Navigator.of(ctx).pop(RecurrenceMoveScope.thisAndFuture),
            ),
            const SizedBox(height: 8),
            _ScopeOption(
              icon: Icons.all_inclusive_rounded,
              title: 'Entire series',
              subtitle: 'Shift every occurrence in this series.',
              onTap: () =>
                  Navigator.of(ctx).pop(RecurrenceMoveScope.entireSeries),
            ),

            // const SizedBox(height: 12),

            // TextButton(
            //   onPressed: () => Navigator.of(ctx).pop(null),
            //   child: const Text('Cancel'),
            // ),
          ],
        ),
      );
    },
  );
}

class _ScopeOption extends StatelessWidget {
  const _ScopeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFB9BFCC).withValues(alpha: 0.9),
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F4AA8).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF1F4AA8).withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(icon, color: const Color(0xFF1F4AA8)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    );
  }
}
