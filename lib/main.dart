import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rrule/rrule.dart';
import 'package:timecraft/app_view/bloc/app_cubit.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_instance_dao.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_override_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_pattern_dao.dart';
import 'package:timecraft/repo/drift/tasks/materialization_worker.dart';
import 'package:timecraft/repo/task_repo.dart';
import 'package:timecraft/repo/repo_service.dart';
import 'package:timecraft/week_calendar/view/week_calendar.dart';
import 'package:timecraft/app_view/view/main_view.dart';

void main() async {
  runApp(const MyApp());

  LocalDB db = LocalDB();
  //db.deleteDb();

  await db.clearAllTables();
  MaterializationWorker worker = MaterializationWorker(db);
  TaskRepo taskRepo = TaskRepo(db, worker);
  taskRepo
      .watchTasksInWindow(
        DateTime.now().subtract(Duration(days: 7)),
        DateTime.now().add(Duration(days: 7)),
      )
      .listen((tasks) {
        for (var task in tasks) {
          print(
            'Task: ${task.taskId}, ${task.title}, ${task.startTime}, ${task.duration}',
          );
        }
      });
  taskRepo.watchUnscheduledTasks().listen((tasks) {
    for (var task in tasks) {
      print(
        'Unscheduled Task: ${task.taskId}, ${task.title}, ${task.startTime}, ${task.duration}',
      );
    }
  });

  await taskRepo.createPattern(
    TaskPattern(
      id: 'pattern1',
      title: 'Daily Standup Meeting',
      description: 'Daily team sync-up meeting',
      startTime: DateTime.now().add(Duration(hours: 1)),
      duration: Duration(minutes: 15),
      rrule: RecurrenceRule(
        frequency: Frequency.daily,
        interval: 1,
        until: DateTime.now().add(Duration(days: 30)).copyWith(isUtc: true),
      ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
  print('Created pattern');
  await Future.delayed(Duration(seconds: 2));
  print('Inserting override...');
  TaskPattern? insertedPattern = await TaskPatternDao(
    db,
  ).getPatternById('pattern1');
  if (insertedPattern != null) {
    print('startTime: ${insertedPattern.startTime}');
    await taskRepo.overrideTask(
      TaskOverride.fromPattern(
        insertedPattern,
        insertedPattern.startTime!,
        title: 'Updated Standup Meeting',
        description: 'Updated description for the daily stand-up meeting',
        startTime: insertedPattern.startTime!.add(Duration(hours: 2)),
        duration: Duration(minutes: 30),
      ),
    );
    await taskRepo.overrideTask(
      TaskOverride.fromPattern(
        insertedPattern,
        insertedPattern.startTime!.add(Duration(days: 1)),
        title: 'Tomorrow\'s Standup Meeting',
        description: 'Stand-up meeting for tomorrow',
        startTime: insertedPattern.startTime!.add(Duration(days: 1, hours: 3)),
        duration: Duration(minutes: 30),
      ),
    );
  }
  taskRepo.createPattern(
    TaskPattern(
      id: 'pattern2',
      title: 'Loundry Day',
      description: 'Weekly loundry day',
      duration: Duration(minutes: 60),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
  taskRepo.overrideTask(
    TaskOverride.fromPattern(
      TaskPattern(
        id: 'pattern2',
        title: 'Loundry Day',
        description: 'Weekly loundry day',
        duration: Duration(minutes: 60),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      DateTime.now().add(Duration(days: 2)),
      startTime: DateTime.now().add(Duration(days: 2, hours: 10)),
    ),
  );
  await Future.delayed(Duration(seconds: 5));

  await db.close();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: RepositoryProvider.value(
        value: RepoService.mock(),
        child: Builder(
          builder: (context) => BlocProvider.value(
            value: AppCubit(context.read<RepoService>()),
            child: MainView(),
          ),
        ),
      ),
    );
  }
}
