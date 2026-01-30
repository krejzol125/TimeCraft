import 'dart:async';
import 'dart:convert';

import 'package:timecraft/repo/drift/tasks/dao/outbox_dao.dart';
import 'package:timecraft/repo/firestore_remote.dart';
import 'package:timecraft/repo/sync/remote_applier.dart';

class SyncEngine {
  SyncEngine({
    required OutboxDao outboxDao,
    required FirestoreRemote remote,
    required RemoteApplier applier,
  }) : _outboxDao = outboxDao,
       _remote = remote,
       _applier = applier;

  final OutboxDao _outboxDao;
  final FirestoreRemote _remote;
  final RemoteApplier _applier;

  String? _uid;
  StreamSubscription? _patSub;
  StreamSubscription? _ovrSub;
  StreamSubscription<int>? _outboxSub;

  Timer? _debounce;
  bool _pushing = false;

  void start(String uid) {
    if (_uid == uid) return;
    stop();
    _uid = uid;

    _patSub = _remote.patterns(uid).snapshots().listen((snap) async {
      for (final ch in snap.docChanges) {
        final data = ch.doc.data();
        if (data == null) continue;
        await _applier.applyPatternDoc(data);
      }
    });

    _ovrSub = _remote.overrides(uid).snapshots().listen((snap) async {
      for (final ch in snap.docChanges) {
        final data = ch.doc.data();
        if (data == null) continue;
        await _applier.applyOverrideDoc(ch.doc.id, data);
      }
    });

    _outboxSub = _outboxDao.watchPendingCount(uid).listen((count) {
      if (count <= 0) return;
      _schedulePush();
    });

    _schedulePush(immediate: true);
  }

  void _schedulePush({bool immediate = false}) {
    _debounce?.cancel();
    if (immediate) {
      unawaited(pushNow());
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 450), () {
      unawaited(pushNow());
    });
  }

  void stop() {
    _uid = null;
    _patSub?.cancel();
    _ovrSub?.cancel();
    _outboxSub?.cancel();
    _outboxSub = null;
    _patSub = null;
    _ovrSub = null;
    _debounce?.cancel();
    _debounce = null;
  }

  Future<void> pushNow() async {
    final uid = _uid;
    if (uid == null) return;
    if (_pushing) return;
    _pushing = true;

    try {
      while (true) {
        final batch = await _outboxDao.nextBatch(uid, limit: 40);
        if (batch.isEmpty) break;

        for (final e in batch) {
          try {
            final payload = jsonDecode(e.payloadJson) as Map<String, dynamic>;

            if (e.entityType == 'pattern') {
              await _remote.pushPattern(uid, payload);
            } else if (e.entityType == 'override') {
              await _remote.pushOverride(uid, e.entityKey, payload);
            }

            await _outboxDao.markSent(e.entityKey);
          } catch (err) {
            //await _outboxDao.markFailed(e.id, err.toString());
            //print('Error pushing ${e.entityType} ${e.entityKey}: $err');
          }
        }
      }
    } finally {
      _pushing = false;
    }
  }
}
