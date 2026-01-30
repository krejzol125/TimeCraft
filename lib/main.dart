import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timecraft/auth/auth_repo.dart';
import 'package:timecraft/auth/session_cubit.dart';
import 'package:timecraft/firebase_options.dart';
import 'package:timecraft/l10n/app_localizations.dart';
import 'package:timecraft/pages/calendar/bloc/calendar_cubit.dart';
import 'package:timecraft/pages/login_page/login_page.dart';
import 'package:timecraft/repo/drift/local_db.dart';
import 'package:timecraft/repo/drift/tasks/dao/outbox_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_override_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_pattern_dao.dart';
import 'package:timecraft/repo/drift/tasks/materialization_worker.dart';
import 'package:timecraft/repo/firestore_remote.dart';
import 'package:timecraft/repo/sync/remote_applier.dart';
import 'package:timecraft/repo/sync/sync_engine.dart';
import 'package:timecraft/repo/task_repo.dart';
import 'package:timecraft/pages/app_view/main_view.dart';

const _localePrefsKey = 'locale';

void main() async {
  // LocalDB db = LocalDB();
  // await db.clearAllTables();
  // await db.close();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  late final AuthRepo _authRepo;
  late final SessionCubit _sessionCubit;

  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _db = LocalDB();
    _worker = MaterializationWorker(_db);
    _taskRepo = TaskRepo(_db, _worker);
    _authRepo = AuthRepo(FirebaseAuth.instance);

    final remote = FirestoreRemote(FirebaseFirestore.instance);
    final applier = RemoteApplier(
      patternDao: TaskPatternDao(_db),
      overrideDao: TaskOverrideDao(_db),
    );

    final syncEngine = SyncEngine(
      outboxDao: OutboxDao(_db),
      remote: remote,
      applier: applier,
    );

    _sessionCubit = SessionCubit(
      authRepo: _authRepo,
      taskRepo: _taskRepo,
      syncEngine: syncEngine,
    );
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
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => CalendarCubit(
                  repo: context.read<TaskRepo>(),
                  initialFromUtc: _thisWeekStart(),
                ),
              ),
              BlocProvider.value(value: _sessionCubit),
            ],
            child: BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                switch (state) {
                  case SessionUnknown():
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  case SessionSignedOut():
                    return const LoginPage();
                  case SessionSignedIn():
                    return MainView(onToggleLocale: _toggleLocale);
                }
              },
            ),
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
