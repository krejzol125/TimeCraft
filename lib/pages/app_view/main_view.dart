import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/model/task_instance.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/pages/add_task_sheet/add_task_multi_sheet.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_cubit.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_state.dart';
import 'package:timecraft/pages/calendar/view/month/month_calendar.dart';
import 'package:timecraft/pages/undated_drawer/view/undated_drawer.dart';
import 'package:timecraft/repo/task_repo.dart';

class MainView extends StatelessWidget {
  MainView({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context1) {
    final Color bgTop = const Color(0xFFeef4ff);
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        //print('Rebuilding MainView with ${state.tasks.length} tasks');
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('WeekCraft'),
            backgroundColor: bgTop,
            leading: IconButton(
              tooltip: 'Account',
              onPressed: () {},
              icon: const Icon(Icons.account_circle_rounded),
            ),

            actions: [
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                ),
              // IconButton(
              //   icon: Icon(Icons.arrow_back_ios_rounded),
              //   onPressed: () {
              //     context.read<CalendarCubit>().previousPeriod();
              //   },
              // ),
              // IconButton(
              //   icon: Icon(Icons.arrow_forward_ios_rounded),
              //   onPressed: () {
              //     context.read<CalendarCubit>().nextPeriod();
              //   },
              // ),
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
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (state.viewMode == CalendarViewMode.week &&
                  constraints.maxWidth < 620) {
                context.read<CalendarCubit>().setViewMode(CalendarViewMode.day);
              }
              if (state.viewMode == CalendarViewMode.day &&
                  constraints.maxWidth >= 620) {
                context.read<CalendarCubit>().setViewMode(
                  CalendarViewMode.week,
                );
              }
              return MonthToDetailPage(
                initialDate: state.selectedUtc,
                tasks: state.tasks,
                repo: context.read<TaskRepo>(),
                setSelectedDate: (date) {
                  context.read<CalendarCubit>().setSelectedDate(date);
                },
                setRange: (date) {
                  context.read<CalendarCubit>().setRange(date);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text('New Task'),
            onPressed: () async {
              TaskPattern? pattern = await AddTaskSheetMultiStep.show(context);
              if (pattern != null) {
                context.read<TaskRepo>().upsertPattern(pattern);
              }
              // await showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   useSafeArea: true,
              //   backgroundColor: Colors.transparent,
              //   builder: (ctx) => AddTaskSheetMultiStep(
              //     onSubmit: context.read<TaskRepo>().createPattern,
              //   ),
              // );
            },
          ),
        );
      },
    );
  }
}
