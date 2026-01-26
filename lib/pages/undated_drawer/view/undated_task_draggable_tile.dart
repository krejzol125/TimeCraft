import 'package:flutter/material.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';

class UndatedDraggableTaskTile extends StatelessWidget {
  const UndatedDraggableTaskTile({
    super.key,
    required this.task,
    required this.onDragStartClose,
  });

  final TaskInstance task;
  final VoidCallback onDragStartClose;

  @override
  Widget build(BuildContext context) {
    return Draggable<DragData>(
      data: DragData(task, DragMode.move),
      onDragStarted: onDragStartClose,
      feedback: const SizedBox.shrink(),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: _UndatedDraggableTaskTileBody(task: task),
      ),
      child: _UndatedDraggableTaskTileBody(task: task),
    );
  }
}

class _UndatedDraggableTaskTileBody extends StatelessWidget {
  final TaskInstance task;
  final double height = 80;

  const _UndatedDraggableTaskTileBody({required this.task});
  @override
  Widget build(BuildContext context) {
    //print('height: $height');

    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: EdgeInsets.all(10),
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
      child: Row(
        children: [
          Container(
            width: 6,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 4),

                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                  softWrap: true,
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
