import 'package:flutter/material.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';

class TaskTile extends StatelessWidget {
  final TaskInstance task;
  final double height;

  const TaskTile({super.key, required this.task, required this.height});

  @override
  Widget build(BuildContext context) {
    final body = _TileBody(task: task, height: height);

    // PRZENOSZENIE (cały kafelek)
    final moveDraggable = Draggable<DragData>(
      data: DragData(task, DragMode.move),
      feedback: const SizedBox.shrink(),
      childWhenDragging: Opacity(opacity: 0.2, child: body),
      dragAnchorStrategy: (details, constraints, child) =>
          Offset(0, height / 2),
      child: body,
    );

    // Uchwyt do ROZCIĄGANIA (dolny pasek)
    final resizeHandle = Positioned(
      left: 12,
      right: 12,
      bottom: 6,
      child: Center(
        child: Container(
          height: 6,
          width: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );

    // DRAG tylko dla uchwytu (resize)
    return Draggable<DragData>(
      data: DragData(task, DragMode.resize),
      feedback: const SizedBox.shrink(),
      childWhenDragging: const SizedBox.shrink(),
      dragAnchorStrategy: pointerDragAnchorStrategy,
      child: Stack(children: [moveDraggable, resizeHandle]),
    );
  }
}

class _TileBody extends StatelessWidget {
  final TaskInstance task;
  final double height;

  const _TileBody({required this.task, required this.height});

  @override
  Widget build(BuildContext context) {
    final start = task.startTime!;
    final end = task.endTime!;
    final timeLabel = '${fmtTime(start)} – ${fmtTime(end)}';
    //print('height: $height');

    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.fromLTRB(
        10,
        height > 50 ? 10 : 4,
        10,
        height > 50 ? 22 : 0,
      ), // miejsce na uchwyt
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.indigo.shade400],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Górny wiersz: „chip” czasu
            if (height > 80) ...[
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  child: Text(
                    timeLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
            // Tytuł
            if (height > 30)
              Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
                softWrap: true,
              ),
            if (height > 112) ...[
              const SizedBox(height: 4),
              // Opis
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.15,
                  color: Colors.white.withOpacity(0.95),
                ),
                softWrap: true,
              ),
            ],
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

String fmtTime(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

// Wygląd ghosta (cień) – opcjonalnie kreskowana ramka przy resize
class GhostTile extends StatelessWidget {
  final String title;
  final double height;
  final DateTime start;
  final DateTime end;
  final DragMode mode;

  const GhostTile({
    required this.title,
    required this.height,
    required this.start,
    required this.end,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final timeLabel = '${fmtTime(start)} – ${fmtTime(end)}';
    final modeLabel = mode == DragMode.move ? 'Przenoszenie' : 'Rozciąganie';

    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.7),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Pasek z czasem u góry
          if (height > 60)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.blueAccent.withOpacity(0.5)),
                ),
                child: Text(
                  timeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          // Tytuł + tryb na środku
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
