import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_override_dao.dart';
import 'package:timecraft/repo/drift/tasks/dao/task_pattern_dao.dart';

class RemoteApplier {
  RemoteApplier({
    required TaskPatternDao patternDao,
    required TaskOverrideDao overrideDao,
  }) : _patternDao = patternDao,
       _overrideDao = overrideDao;

  final TaskPatternDao _patternDao;
  final TaskOverrideDao _overrideDao;

  Future<void> applyPatternDoc(Map<String, dynamic> m) async {
    final remote = TaskPattern.fromMap(m);
    final local = await _patternDao.getPatternById(remote.id);
    if (local == null || remote.rev > local.rev) {
      print('applying pattern ${remote.title} rev ${remote.startTime}');
      await _patternDao.upsertPattern(remote);
      //await _patternDao.markPatternDirty(remote.id, remote.rev);
    }
  }

  Future<void> applyOverrideDoc(
    String overrideId,
    Map<String, dynamic> m,
  ) async {
    final remote = TaskOverride.fromMap(m);
    final local = await _overrideDao.getOverrideById(remote.taskId, remote.rid);
    final localRev = local?.rev ?? 0;
    if (local == null || remote.rev > localRev) {
      await _overrideDao.upsertOverride(remote);
      await _patternDao.markPatternDirty(remote.taskId, remote.rev);
    }
  }
}
