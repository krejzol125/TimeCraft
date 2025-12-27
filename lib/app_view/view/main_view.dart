import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/app_view/bloc/app_cubit.dart';
import 'package:timecraft/app_view/bloc/app_state.dart';
import 'package:timecraft/week_calendar/view/week_calendar.dart';
import 'package:timecraft/add_task_sheet/view/add_task_sheet.dart';
import 'package:timecraft/undated_drawer/view/undated_drawer.dart';

class MainView extends StatelessWidget {
  MainView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context1) {
    return BlocBuilder<AppCubit, AppState>(
      //bloc: AppCubit(context1.read<RepoService>()),
      builder: (context, state) {
        // if (state is AppWeekLoaded) {
        //   for (var task in state.tasks) {
        //     print(task.startTime);
        //   }
        // }
        final undated = state.tasks
            .where((t) => t.startTime == null || t.endTime == null)
            .toList(); // TODO upewnić się że tasks ma taski bez dat
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Week Calendar'),
            actions: [
              IconButton(
                tooltip: 'Undated tasks',
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                icon: const Icon(Icons.inbox_outlined),
              ),
            ],
          ),
          endDrawerEnableOpenDragGesture: false,
          endDrawer: UndatedDrawer(
            undated: undated,
            onDragStartClose: () {
              _scaffoldKey.currentState?.closeEndDrawer();
            },
          ),
          body: switch (state) {
            AppInitial() => const WeekLoading(),
            AppWeekLoaded() => Weekcalendar(state.tasks),
            AppWeekLoading() => const WeekLoading(),
          },
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text('New Task'),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) =>
                    AddTaskSheet(onSubmit: context.read<AppCubit>().addTask),
              );
            },
          ),
        );
      },
    );
  }
}
