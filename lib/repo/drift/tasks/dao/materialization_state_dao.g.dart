// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materialization_state_dao.dart';

// ignore_for_file: type=lint
mixin _$MaterializationStateDaoMixin on DatabaseAccessor<LocalDB> {
  $MaterializationStatesTable get materializationStates =>
      attachedDatabase.materializationStates;
  MaterializationStateDaoManager get managers =>
      MaterializationStateDaoManager(this);
}

class MaterializationStateDaoManager {
  final _$MaterializationStateDaoMixin _db;
  MaterializationStateDaoManager(this._db);
  $$MaterializationStatesTableTableManager get materializationStates =>
      $$MaterializationStatesTableTableManager(
        _db.attachedDatabase,
        _db.materializationStates,
      );
}
