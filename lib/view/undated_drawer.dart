import 'package:flutter/material.dart';
import 'package:timecraft/model/drag_data.dart';
import 'package:timecraft/model/task_instance.dart';

class UndatedDrawer extends StatelessWidget {
  const UndatedDrawer({required this.undated, required this.onDragStartClose});

  final List<TaskInstance> undated;
  final VoidCallback onDragStartClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SizedBox(
        width: 340,
        child: Drawer(
          elevation: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Undated tasks',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Expanded(
                child: undated.isEmpty
                    ? const Center(child: Text('No undated tasks'))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemBuilder: (ctx, i) {
                          final t = undated[i];
                          return _UndatedTaskDraggable(
                            task: t,
                            onDragStartClose: onDragStartClose,
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemCount: undated.length,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UndatedTaskDraggable extends StatelessWidget {
  const _UndatedTaskDraggable({
    required this.task,
    required this.onDragStartClose,
  });

  final TaskInstance task;
  final VoidCallback onDragStartClose;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.drag_indicator),
        title: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          task.description.isEmpty ? 'No description' : task.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.calendar_today_outlined, size: 18),
      ),
    );

    return Draggable<DragData>(
      data: DragData(task, DragMode.move),
      onDragStarted:
          onDragStartClose, // <<< zamknij szufladę gdy zaczynasz drag
      feedback: const SizedBox.shrink(),
      childWhenDragging: Opacity(opacity: 0.4, child: card),
      child: card,
    );
  }
}
