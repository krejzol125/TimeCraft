// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_override_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskOverrideDaoMixin on DatabaseAccessor<LocalDB> {
  $TaskPatternsTable get taskPatterns => attachedDatabase.taskPatterns;
  $TaskOverridesTable get taskOverrides => attachedDatabase.taskOverrides;
  TaskOverrideDaoManager get managers => TaskOverrideDaoManager(this);
}

class TaskOverrideDaoManager {
  final _$TaskOverrideDaoMixin _db;
  TaskOverrideDaoManager(this._db);
  $$TaskPatternsTableTableManager get taskPatterns =>
      $$TaskPatternsTableTableManager(_db.attachedDatabase, _db.taskPatterns);
  $$TaskOverridesTableTableManager get taskOverrides =>
      $$TaskOverridesTableTableManager(_db.attachedDatabase, _db.taskOverrides);
}
