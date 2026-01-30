import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/pages/calendar/view/detailed/task_tile.dart';

class GhostTile extends StatelessWidget {
  final String title;
  final double height;
  final DateTime start;
  final DateTime end;
  final DragMode mode;

  const GhostTile({
    super.key,
    required this.title,
    required this.height,
    required this.start,
    required this.end,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timeLabel = '${timeToString(start)} - ${timeToString(end)}';
    final modeLabel = mode == DragMode.move ? l10n.ghostMove : l10n.ghostResize;

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.blueAccent.withValues(alpha: 0.7),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (height > 60)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.blueAccent.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  timeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (height > 30)
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  if (height > 75) ...[
                    const SizedBox(height: 4),
                    Text(
                      modeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
