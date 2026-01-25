// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_instance_dao.dart';

// ignore_for_file: type=lint
mixin _$TaskInstanceDaoMixin on DatabaseAccessor<LocalDB> {
  $TaskPatternsTable get taskPatterns => attachedDatabase.taskPatterns;
  $TaskInstancesTable get taskInstances => attachedDatabase.taskInstances;
  TaskInstanceDaoManager get managers => TaskInstanceDaoManager(this);
}

class TaskInstanceDaoManager {
  final _$TaskInstanceDaoMixin _db;
  TaskInstanceDaoManager(this._db);
  $$TaskPatternsTableTableManager get taskPatterns =>
      $$TaskPatternsTableTableManager(_db.attachedDatabase, _db.taskPatterns);
  $$TaskInstancesTableTableManager get taskInstances =>
      $$TaskInstancesTableTableManager(_db.attachedDatabase, _db.taskInstances);
}
