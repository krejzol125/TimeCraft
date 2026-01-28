import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timecraft/pages/week_calendar/bloc/calendar_cubit.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/materialization_worker.dart';
import 'package:timecraft/repo/task_repo.dart';
import 'package:timecraft/pages/app_view/view/main_view.dart';

void main() async {
  // LocalDB db = LocalDB();
  // await db.deleteDb();
  // await db.close();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalDB db = LocalDB();
    //db.clearAllTables();
    MaterializationWorker worker = MaterializationWorker(db);
    TaskRepo taskRepo = TaskRepo(db, worker);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TimeCraft',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: RepositoryProvider.value(
        value: taskRepo,
        child: Builder(
          builder: (context) => BlocProvider.value(
            value: CalendarCubit(
              repo: context.read<TaskRepo>(),
              initialFromUtc: _thisWeekStart(),
              initialToUtc: _thisWeekStart().add(Duration(days: 7)),
            ),
            child: MainView(),
          ),
        ),
      ),
    );
  }

  static DateTime _thisWeekStart() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }
}
