import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/pages/week_calendar/bloc/calendar_cubit.dart';
import 'package:timecraft/pages/week_calendar/bloc/calendar_state.dart';
import 'package:timecraft/pages/week_calendar/view/week_calendar.dart';
import 'package:timecraft/pages/add_task_sheet/view/add_task_sheet.dart';
import 'package:timecraft/pages/undated_drawer/view/undated_drawer.dart';
import 'package:timecraft/repo/task_repo.dart';

class MainView extends StatelessWidget {
  MainView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context1) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      //bloc: AppCubit(context1.read<RepoService>()),
      builder: (context, state) {
        // if (state is AppWeekLoaded) {
        //   for (var task in state.tasks) {
        //     print(task.startTime);
        //   }
        // }
        print('Rebuilding MainView with ${state.tasks.length} tasks');
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
          endDrawer: StreamBuilder<List<TaskInstance>>(
            stream: context.read<TaskRepo>().watchUnscheduledTasks(),
            builder: (context, snapshot) {
              return UndatedDrawer(
                undated: snapshot.data ?? [],
                onDragStartClose: () {
                  _scaffoldKey.currentState?.closeEndDrawer();
                },
              );
            },
          ),
          body: WeekCalendar(state.tasks, state.fromUtc),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text('New Task'),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => AddTaskSheet(
                  onSubmit: context.read<TaskRepo>().createPattern,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
