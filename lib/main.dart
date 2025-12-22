import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timecraft/service/bloc/app_cubit.dart';
import 'package:timecraft/service/repo/repo_service.dart';
import 'package:timecraft/view/WeekCalendar/week_calendar.dart';
import 'package:timecraft/view/main_view.dart';

void main() {
  runApp(const MyApp());
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
