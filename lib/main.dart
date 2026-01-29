import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_cubit.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/materialization_worker.dart';
import 'package:timecraft/repo/task_repo.dart';
import 'package:timecraft/pages/app_view/main_view.dart';

const _localePrefsKey = 'locale';

void main() async {
  // LocalDB db = LocalDB();
  // await db.clearAllTables();
  // await db.close();
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final code = prefs.getString(_localePrefsKey) ?? 'pl';
  runApp(MyApp(initialLocale: Locale(code)));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.initialLocale});

  final Locale initialLocale;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LocalDB _db;
  late final MaterializationWorker _worker;
  late final TaskRepo _taskRepo;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _db = LocalDB();
    _worker = MaterializationWorker(_db);
    _taskRepo = TaskRepo(_db, _worker);
  }

  Future<void> _toggleLocale() async {
    setState(() {
      _locale = _locale.languageCode == 'pl'
          ? const Locale('en')
          : const Locale('pl');
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localePrefsKey, _locale.languageCode);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: RepositoryProvider.value(
        value: _taskRepo,
        child: Builder(
          builder: (context) => BlocProvider.value(
            value: CalendarCubit(
              repo: context.read<TaskRepo>(),
              initialFromUtc: _thisWeekStart(),
            ),
            child: MainView(onToggleLocale: _toggleLocale),
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
