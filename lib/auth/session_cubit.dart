import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timecraft/auth/auth_repo.dart';
import 'package:timecraft/repo/sync/sync_engine.dart';
import 'package:timecraft/repo/task_repo.dart';

sealed class SessionState {
  const SessionState();
}

class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionSignedOut extends SessionState {
  const SessionSignedOut();
}

class SessionSignedIn extends SessionState {
  final String uid;
  final String email;
  const SessionSignedIn(this.uid, this.email);
}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required AuthRepo authRepo,
    required TaskRepo taskRepo,
    required SyncEngine syncEngine,
  }) : _authRepo = authRepo,
       _taskRepo = taskRepo,
       _syncEngine = syncEngine,
       super(const SessionUnknown()) {
    _sub = _authRepo.authState().listen(_onAuth);
  }

  final AuthRepo _authRepo;
  final TaskRepo _taskRepo;
  final SyncEngine _syncEngine;
  StreamSubscription<User?>? _sub;

  void _onAuth(User? user) {
    if (user == null) {
      _syncEngine.stop();
      _taskRepo.setUser(null);
      _taskRepo.clear();
      emit(const SessionSignedOut());
      return;
    }
    final uid = user.uid;
    _taskRepo.setUser(uid);
    _syncEngine.start(uid);
    final email = _authRepo.getUserEmail();
    emit(SessionSignedIn(uid, email));
  }

  Future<void> signIn(String email, String pass) async {
    await _authRepo.signInEmail(email, pass);
  }

  Future<void> signUp(String email, String pass) async {
    await _authRepo.signUpEmail(email, pass);
  }

  Future<void> signOut() async {
    await _authRepo.signOut();
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
