import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/calendar/view/detailed/ghost_tile.dart';
import 'package:timecraft/pages/calendar/view/detailed/task_tile.dart';

class DayColumn extends StatelessWidget {
  const DayColumn({
    super.key,
    required this.day,
    required this.dayKey,
    required this.dayStart,
    required this.halfHourHeight,
    required this.pixelsPerMinute,
    required this.tasksForDay,
    required this.ghost,
    required this.onMoveGhost,
    required this.onLeaveGhost,
    required this.onDrop,
  });

  final String day;
  final GlobalKey dayKey;

  final DateTime dayStart;
  static const int halfHoursPerDay = 48;
  final double halfHourHeight;
  final double pixelsPerMinute;

  final List<TaskInstance> tasksForDay;

  final ValueListenable<GhostState?> ghost;

  final void Function(String day, DragData data, Offset globalOffset)
  onMoveGhost;
  final VoidCallback onLeaveGhost;

  final Future<void> Function(DragData data) onDrop;

  double _dateToTopOffset(DateTime startTime) =>
      (startTime.hour * 60 + startTime.minute) * pixelsPerMinute;

  double _dateToHeight(DateTime startTime, DateTime endTime) =>
      endTime.difference(startTime).inMinutes * pixelsPerMinute;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: dayKey,
      height: halfHourHeight * halfHoursPerDay,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: DragTarget<DragData>(
        onMove: (details) => onMoveGhost(day, details.data, details.offset),
        onLeave: (_) => onLeaveGhost(),
        onAcceptWithDetails: (details) async => onDrop(details.data),
        builder: (context, candidateItems, rejectedItems) {
          return Stack(
            children: [
              // grid
              ...List.generate(
                halfHoursPerDay,
                (i) => Positioned(
                  top: i * halfHourHeight,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: halfHourHeight,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.8,
                        ),
                      ),
                      color: i.isOdd
                          ? Colors.blueGrey.withValues(alpha: 0.015)
                          : Colors.transparent,
                    ),
                  ),
                ),
              ),

              // tasks
              for (final event in tasksForDay)
                Positioned(
                  top: _dateToTopOffset(event.startTime!),
                  left: 2,
                  right: 2,
                  child: TaskTile(
                    task: event,
                    height: _dateToHeight(event.startTime!, event.endTime!),
                  ),
                ),

              // ghost
              ValueListenableBuilder<GhostState?>(
                valueListenable: ghost,
                builder: (context, g, _) {
                  if (g == null || g.day != day) return const SizedBox.shrink();

                  final top = _dateToTopOffset(
                    g.data.mode == DragMode.move
                        ? g.start
                        : g.data.task.startTime!,
                  );

                  final end = () {
                    if (g.data.mode == DragMode.move) {
                      final dur =
                          g.data.task.duration ?? const Duration(hours: 1);
                      return g.start.add(dur);
                    } else {
                      final minutes = (g.height / pixelsPerMinute).round();
                      return g.data.task.startTime!.add(
                        Duration(minutes: minutes),
                      );
                    }
                  }();

                  return Positioned(
                    top: top,
                    left: 2,
                    right: 2,
                    child: IgnorePointer(
                      child: GhostTile(
                        title: g.data.task.title,
                        height: g.height,
                        start: g.start,
                        end: end,
                        mode: g.data.mode,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class GhostState {
  final String day;
  final DateTime start;
  final double height;
  final DragData data;

  GhostState({
    required this.day,
    required this.start,
    required this.height,
    required this.data,
  });
}
