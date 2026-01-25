// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_pattern_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskPatternDaoMixin on DatabaseAccessor<LocalDB> {
  $TaskPatternsTable get taskPatterns => attachedDatabase.taskPatterns;
  TaskPatternDaoManager get managers => TaskPatternDaoManager(this);
}

class TaskPatternDaoManager {
  final _$TaskPatternDaoMixin _db;
  TaskPatternDaoManager(this._db);
  $$TaskPatternsTableTableManager get taskPatterns =>
      $$TaskPatternsTableTableManager(_db.attachedDatabase, _db.taskPatterns);
}
