import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/pages/add_task_sheet/add_task_multi_sheet.dart';
import 'package:timecraft/pages/task_detail_sheet/task_detail_sheet.dart';
import 'package:timecraft/repo/task_repo.dart';

class TaskTile extends StatelessWidget {
  final TaskInstance task;
  final double height;

  const TaskTile({super.key, required this.task, required this.height});

  @override
  Widget build(BuildContext context) {
    final body = _TileBody(task: task, height: height);

    final moveDraggable = Draggable<DragData>(
      data: DragData(task, DragMode.move),
      feedback: const SizedBox.shrink(),
      childWhenDragging: Opacity(opacity: 0.2, child: body),
      dragAnchorStrategy: (details, constraints, child) =>
          Offset(0, height / 2),
      child: body,
    );

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
    final timeLabel = '${timeToString(start)} - ${timeToString(end)}';
    //print('height: $height');

    return GestureDetector(
      onTap: () {
        TaskDetailsSheet.show(
          context,
          task: task,
          repo: context.read<TaskRepo>(),
        );
      },
      child: Container(
        height: height,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.fromLTRB(
          10,
          height > 60 ? 10 : 4,
          10,
          height > 60 ? 22 : 0,
        ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (height > 100) ...[
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
                    maxLines: 1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],

            if (height > 40)
              Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                softWrap: true,
              ),
            if (height > 112) ...[
              const SizedBox(height: 4),

              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.95),
                ),
                softWrap: true,
              ),
            ],
            //const Spacer(),
          ],
        ),
      ),
    );
  }
}

String timeToString(DateTime time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}
