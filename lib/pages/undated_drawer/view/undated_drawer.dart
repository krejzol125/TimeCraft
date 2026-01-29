import 'package:flutter/material.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/undated_drawer/view/undated_task_draggable_tile.dart';

class UndatedDrawer extends StatelessWidget {
  const UndatedDrawer({required this.undated, required this.onDragStartClose});

  final List<TaskInstance> undated;
  final VoidCallback onDragStartClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    l10n.undatedTasks,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: undated.isEmpty
                    ? Center(child: Text(l10n.noUndatedTasks))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        itemBuilder: (ctx, i) {
                          final t = undated[i];
                          return UndatedDraggableTaskTile(
                            task: t,
                            onDragStartClose: onDragStartClose,
                          );
                        },
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
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
