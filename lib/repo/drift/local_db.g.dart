// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_db.dart';

// ignore_for_file: type=lint
class $TaskPatternsTable extends TaskPatterns
    with TableInfo<$TaskPatternsTable, TaskPatternEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskPatternsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completionMeta = const VerificationMeta(
    'completion',
  );
  @override
  late final GeneratedColumn<String> completion = GeneratedColumn<String>(
    'completion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0 false'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rruleMeta = const VerificationMeta('rrule');
  @override
  late final GeneratedColumn<String> rrule = GeneratedColumn<String>(
    'rrule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rdatesMeta = const VerificationMeta('rdates');
  @override
  late final GeneratedColumn<String> rdates = GeneratedColumn<String>(
    'rdates',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exdatesMeta = const VerificationMeta(
    'exdates',
  );
  @override
  late final GeneratedColumn<String> exdates = GeneratedColumn<String>(
    'exdates',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _remindersMeta = const VerificationMeta(
    'reminders',
  );
  @override
  late final GeneratedColumn<String> reminders = GeneratedColumn<String>(
    'reminders',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subTasksMeta = const VerificationMeta(
    'subTasks',
  );
  @override
  late final GeneratedColumn<String> subTasks = GeneratedColumn<String>(
    'sub_tasks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _revMeta = const VerificationMeta('rev');
  @override
  late final GeneratedColumn<int> rev = GeneratedColumn<int>(
    'rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    completion,
    description,
    startTime,
    duration,
    rrule,
    rdates,
    exdates,
    tags,
    priority,
    reminders,
    subTasks,
    deleted,
    rev,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_patterns';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskPatternEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('completion')) {
      context.handle(
        _completionMeta,
        completion.isAcceptableOrUnknown(data['completion']!, _completionMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('rrule')) {
      context.handle(
        _rruleMeta,
        rrule.isAcceptableOrUnknown(data['rrule']!, _rruleMeta),
      );
    }
    if (data.containsKey('rdates')) {
      context.handle(
        _rdatesMeta,
        rdates.isAcceptableOrUnknown(data['rdates']!, _rdatesMeta),
      );
    }
    if (data.containsKey('exdates')) {
      context.handle(
        _exdatesMeta,
        exdates.isAcceptableOrUnknown(data['exdates']!, _exdatesMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('reminders')) {
      context.handle(
        _remindersMeta,
        reminders.isAcceptableOrUnknown(data['reminders']!, _remindersMeta),
      );
    }
    if (data.containsKey('sub_tasks')) {
      context.handle(
        _subTasksMeta,
        subTasks.isAcceptableOrUnknown(data['sub_tasks']!, _subTasksMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('rev')) {
      context.handle(
        _revMeta,
        rev.isAcceptableOrUnknown(data['rev']!, _revMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskPatternEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskPatternEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      completion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      rrule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rrule'],
      ),
      rdates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rdates'],
      ),
      exdates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exdates'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      reminders: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminders'],
      ),
      subTasks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_tasks'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      rev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rev'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskPatternsTable createAlias(String alias) {
    return $TaskPatternsTable(attachedDatabase, alias);
  }
}

class TaskPatternEntry extends DataClass
    implements Insertable<TaskPatternEntry> {
  final String id;
  final String title;
  final String completion;
  final String? description;
  final DateTime? startTime;
  final int? duration;
  final String? rrule;
  final String? rdates;
  final String? exdates;
  final String? tags;
  final int priority;
  final String? reminders;
  final String? subTasks;
  final bool deleted;
  final int rev;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskPatternEntry({
    required this.id,
    required this.title,
    required this.completion,
    this.description,
    this.startTime,
    this.duration,
    this.rrule,
    this.rdates,
    this.exdates,
    this.tags,
    required this.priority,
    this.reminders,
    this.subTasks,
    required this.deleted,
    required this.rev,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['completion'] = Variable<String>(completion);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || rrule != null) {
      map['rrule'] = Variable<String>(rrule);
    }
    if (!nullToAbsent || rdates != null) {
      map['rdates'] = Variable<String>(rdates);
    }
    if (!nullToAbsent || exdates != null) {
      map['exdates'] = Variable<String>(exdates);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || reminders != null) {
      map['reminders'] = Variable<String>(reminders);
    }
    if (!nullToAbsent || subTasks != null) {
      map['sub_tasks'] = Variable<String>(subTasks);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['rev'] = Variable<int>(rev);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskPatternsCompanion toCompanion(bool nullToAbsent) {
    return TaskPatternsCompanion(
      id: Value(id),
      title: Value(title),
      completion: Value(completion),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      rrule: rrule == null && nullToAbsent
          ? const Value.absent()
          : Value(rrule),
      rdates: rdates == null && nullToAbsent
          ? const Value.absent()
          : Value(rdates),
      exdates: exdates == null && nullToAbsent
          ? const Value.absent()
          : Value(exdates),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      priority: Value(priority),
      reminders: reminders == null && nullToAbsent
          ? const Value.absent()
          : Value(reminders),
      subTasks: subTasks == null && nullToAbsent
          ? const Value.absent()
          : Value(subTasks),
      deleted: Value(deleted),
      rev: Value(rev),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskPatternEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskPatternEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      completion: serializer.fromJson<String>(json['completion']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      duration: serializer.fromJson<int?>(json['duration']),
      rrule: serializer.fromJson<String?>(json['rrule']),
      rdates: serializer.fromJson<String?>(json['rdates']),
      exdates: serializer.fromJson<String?>(json['exdates']),
      tags: serializer.fromJson<String?>(json['tags']),
      priority: serializer.fromJson<int>(json['priority']),
      reminders: serializer.fromJson<String?>(json['reminders']),
      subTasks: serializer.fromJson<String?>(json['subTasks']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      rev: serializer.fromJson<int>(json['rev']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'completion': serializer.toJson<String>(completion),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'duration': serializer.toJson<int?>(duration),
      'rrule': serializer.toJson<String?>(rrule),
      'rdates': serializer.toJson<String?>(rdates),
      'exdates': serializer.toJson<String?>(exdates),
      'tags': serializer.toJson<String?>(tags),
      'priority': serializer.toJson<int>(priority),
      'reminders': serializer.toJson<String?>(reminders),
      'subTasks': serializer.toJson<String?>(subTasks),
      'deleted': serializer.toJson<bool>(deleted),
      'rev': serializer.toJson<int>(rev),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskPatternEntry copyWith({
    String? id,
    String? title,
    String? completion,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> startTime = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<String?> rrule = const Value.absent(),
    Value<String?> rdates = const Value.absent(),
    Value<String?> exdates = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    int? priority,
    Value<String?> reminders = const Value.absent(),
    Value<String?> subTasks = const Value.absent(),
    bool? deleted,
    int? rev,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskPatternEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    completion: completion ?? this.completion,
    description: description.present ? description.value : this.description,
    startTime: startTime.present ? startTime.value : this.startTime,
    duration: duration.present ? duration.value : this.duration,
    rrule: rrule.present ? rrule.value : this.rrule,
    rdates: rdates.present ? rdates.value : this.rdates,
    exdates: exdates.present ? exdates.value : this.exdates,
    tags: tags.present ? tags.value : this.tags,
    priority: priority ?? this.priority,
    reminders: reminders.present ? reminders.value : this.reminders,
    subTasks: subTasks.present ? subTasks.value : this.subTasks,
    deleted: deleted ?? this.deleted,
    rev: rev ?? this.rev,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskPatternEntry copyWithCompanion(TaskPatternsCompanion data) {
    return TaskPatternEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      completion: data.completion.present
          ? data.completion.value
          : this.completion,
      description: data.description.present
          ? data.description.value
          : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      rrule: data.rrule.present ? data.rrule.value : this.rrule,
      rdates: data.rdates.present ? data.rdates.value : this.rdates,
      exdates: data.exdates.present ? data.exdates.value : this.exdates,
      tags: data.tags.present ? data.tags.value : this.tags,
      priority: data.priority.present ? data.priority.value : this.priority,
      reminders: data.reminders.present ? data.reminders.value : this.reminders,
      subTasks: data.subTasks.present ? data.subTasks.value : this.subTasks,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      rev: data.rev.present ? data.rev.value : this.rev,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskPatternEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completion: $completion, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('duration: $duration, ')
          ..write('rrule: $rrule, ')
          ..write('rdates: $rdates, ')
          ..write('exdates: $exdates, ')
          ..write('tags: $tags, ')
          ..write('priority: $priority, ')
          ..write('reminders: $reminders, ')
          ..write('subTasks: $subTasks, ')
          ..write('deleted: $deleted, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    completion,
    description,
    startTime,
    duration,
    rrule,
    rdates,
    exdates,
    tags,
    priority,
    reminders,
    subTasks,
    deleted,
    rev,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskPatternEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.completion == this.completion &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.duration == this.duration &&
          other.rrule == this.rrule &&
          other.rdates == this.rdates &&
          other.exdates == this.exdates &&
          other.tags == this.tags &&
          other.priority == this.priority &&
          other.reminders == this.reminders &&
          other.subTasks == this.subTasks &&
          other.deleted == this.deleted &&
          other.rev == this.rev &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskPatternsCompanion extends UpdateCompanion<TaskPatternEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> completion;
  final Value<String?> description;
  final Value<DateTime?> startTime;
  final Value<int?> duration;
  final Value<String?> rrule;
  final Value<String?> rdates;
  final Value<String?> exdates;
  final Value<String?> tags;
  final Value<int> priority;
  final Value<String?> reminders;
  final Value<String?> subTasks;
  final Value<bool> deleted;
  final Value<int> rev;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskPatternsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.completion = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.rrule = const Value.absent(),
    this.rdates = const Value.absent(),
    this.exdates = const Value.absent(),
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.reminders = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskPatternsCompanion.insert({
    required String id,
    required String title,
    this.completion = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.rrule = const Value.absent(),
    this.rdates = const Value.absent(),
    this.exdates = const Value.absent(),
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.reminders = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rev = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<TaskPatternEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? completion,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<int>? duration,
    Expression<String>? rrule,
    Expression<String>? rdates,
    Expression<String>? exdates,
    Expression<String>? tags,
    Expression<int>? priority,
    Expression<String>? reminders,
    Expression<String>? subTasks,
    Expression<bool>? deleted,
    Expression<int>? rev,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (completion != null) 'completion': completion,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (duration != null) 'duration': duration,
      if (rrule != null) 'rrule': rrule,
      if (rdates != null) 'rdates': rdates,
      if (exdates != null) 'exdates': exdates,
      if (tags != null) 'tags': tags,
      if (priority != null) 'priority': priority,
      if (reminders != null) 'reminders': reminders,
      if (subTasks != null) 'sub_tasks': subTasks,
      if (deleted != null) 'deleted': deleted,
      if (rev != null) 'rev': rev,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskPatternsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? completion,
    Value<String?>? description,
    Value<DateTime?>? startTime,
    Value<int?>? duration,
    Value<String?>? rrule,
    Value<String?>? rdates,
    Value<String?>? exdates,
    Value<String?>? tags,
    Value<int>? priority,
    Value<String?>? reminders,
    Value<String?>? subTasks,
    Value<bool>? deleted,
    Value<int>? rev,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskPatternsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      completion: completion ?? this.completion,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      rrule: rrule ?? this.rrule,
      rdates: rdates ?? this.rdates,
      exdates: exdates ?? this.exdates,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      reminders: reminders ?? this.reminders,
      subTasks: subTasks ?? this.subTasks,
      deleted: deleted ?? this.deleted,
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completion.present) {
      map['completion'] = Variable<String>(completion.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (rrule.present) {
      map['rrule'] = Variable<String>(rrule.value);
    }
    if (rdates.present) {
      map['rdates'] = Variable<String>(rdates.value);
    }
    if (exdates.present) {
      map['exdates'] = Variable<String>(exdates.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (reminders.present) {
      map['reminders'] = Variable<String>(reminders.value);
    }
    if (subTasks.present) {
      map['sub_tasks'] = Variable<String>(subTasks.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rev.present) {
      map['rev'] = Variable<int>(rev.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskPatternsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completion: $completion, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('duration: $duration, ')
          ..write('rrule: $rrule, ')
          ..write('rdates: $rdates, ')
          ..write('exdates: $exdates, ')
          ..write('tags: $tags, ')
          ..write('priority: $priority, ')
          ..write('reminders: $reminders, ')
          ..write('subTasks: $subTasks, ')
          ..write('deleted: $deleted, ')
          ..write('rev: $rev, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskInstancesTable extends TaskInstances
    with TableInfo<$TaskInstancesTable, TaskInstanceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_patterns (id)',
    ),
  );
  static const VerificationMeta _ridMeta = const VerificationMeta('rid');
  @override
  late final GeneratedColumn<DateTime> rid = GeneratedColumn<DateTime>(
    'rid',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completionMeta = const VerificationMeta(
    'completion',
  );
  @override
  late final GeneratedColumn<String> completion = GeneratedColumn<String>(
    'completion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('0 false'),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRepeatingMeta = const VerificationMeta(
    'isRepeating',
  );
  @override
  late final GeneratedColumn<bool> isRepeating = GeneratedColumn<bool>(
    'is_repeating',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_repeating" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _remindersMeta = const VerificationMeta(
    'reminders',
  );
  @override
  late final GeneratedColumn<String> reminders = GeneratedColumn<String>(
    'reminders',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subTasksMeta = const VerificationMeta(
    'subTasks',
  );
  @override
  late final GeneratedColumn<String> subTasks = GeneratedColumn<String>(
    'sub_tasks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    rid,
    title,
    completion,
    description,
    startTime,
    duration,
    isRepeating,
    tags,
    priority,
    reminders,
    subTasks,
    deleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskInstanceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('rid')) {
      context.handle(
        _ridMeta,
        rid.isAcceptableOrUnknown(data['rid']!, _ridMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('completion')) {
      context.handle(
        _completionMeta,
        completion.isAcceptableOrUnknown(data['completion']!, _completionMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('is_repeating')) {
      context.handle(
        _isRepeatingMeta,
        isRepeating.isAcceptableOrUnknown(
          data['is_repeating']!,
          _isRepeatingMeta,
        ),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('reminders')) {
      context.handle(
        _remindersMeta,
        reminders.isAcceptableOrUnknown(data['reminders']!, _remindersMeta),
      );
    }
    if (data.containsKey('sub_tasks')) {
      context.handle(
        _subTasksMeta,
        subTasks.isAcceptableOrUnknown(data['sub_tasks']!, _subTasksMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, rid};
  @override
  TaskInstanceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskInstanceEntry(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      rid: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rid'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      completion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      isRepeating: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_repeating'],
      )!,
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      reminders: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminders'],
      ),
      subTasks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_tasks'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskInstancesTable createAlias(String alias) {
    return $TaskInstancesTable(attachedDatabase, alias);
  }
}

class TaskInstanceEntry extends DataClass
    implements Insertable<TaskInstanceEntry> {
  final String taskId;
  final DateTime? rid;
  final String title;
  final String completion;
  final String? description;
  final DateTime? startTime;
  final int? duration;
  final bool isRepeating;
  final String? tags;
  final int priority;
  final String? reminders;
  final String? subTasks;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskInstanceEntry({
    required this.taskId,
    this.rid,
    required this.title,
    required this.completion,
    this.description,
    this.startTime,
    this.duration,
    required this.isRepeating,
    this.tags,
    required this.priority,
    this.reminders,
    this.subTasks,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    if (!nullToAbsent || rid != null) {
      map['rid'] = Variable<DateTime>(rid);
    }
    map['title'] = Variable<String>(title);
    map['completion'] = Variable<String>(completion);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    map['is_repeating'] = Variable<bool>(isRepeating);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || reminders != null) {
      map['reminders'] = Variable<String>(reminders);
    }
    if (!nullToAbsent || subTasks != null) {
      map['sub_tasks'] = Variable<String>(subTasks);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskInstancesCompanion toCompanion(bool nullToAbsent) {
    return TaskInstancesCompanion(
      taskId: Value(taskId),
      rid: rid == null && nullToAbsent ? const Value.absent() : Value(rid),
      title: Value(title),
      completion: Value(completion),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      isRepeating: Value(isRepeating),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      priority: Value(priority),
      reminders: reminders == null && nullToAbsent
          ? const Value.absent()
          : Value(reminders),
      subTasks: subTasks == null && nullToAbsent
          ? const Value.absent()
          : Value(subTasks),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskInstanceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskInstanceEntry(
      taskId: serializer.fromJson<String>(json['taskId']),
      rid: serializer.fromJson<DateTime?>(json['rid']),
      title: serializer.fromJson<String>(json['title']),
      completion: serializer.fromJson<String>(json['completion']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      duration: serializer.fromJson<int?>(json['duration']),
      isRepeating: serializer.fromJson<bool>(json['isRepeating']),
      tags: serializer.fromJson<String?>(json['tags']),
      priority: serializer.fromJson<int>(json['priority']),
      reminders: serializer.fromJson<String?>(json['reminders']),
      subTasks: serializer.fromJson<String?>(json['subTasks']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'rid': serializer.toJson<DateTime?>(rid),
      'title': serializer.toJson<String>(title),
      'completion': serializer.toJson<String>(completion),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'duration': serializer.toJson<int?>(duration),
      'isRepeating': serializer.toJson<bool>(isRepeating),
      'tags': serializer.toJson<String?>(tags),
      'priority': serializer.toJson<int>(priority),
      'reminders': serializer.toJson<String?>(reminders),
      'subTasks': serializer.toJson<String?>(subTasks),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskInstanceEntry copyWith({
    String? taskId,
    Value<DateTime?> rid = const Value.absent(),
    String? title,
    String? completion,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> startTime = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    bool? isRepeating,
    Value<String?> tags = const Value.absent(),
    int? priority,
    Value<String?> reminders = const Value.absent(),
    Value<String?> subTasks = const Value.absent(),
    bool? deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskInstanceEntry(
    taskId: taskId ?? this.taskId,
    rid: rid.present ? rid.value : this.rid,
    title: title ?? this.title,
    completion: completion ?? this.completion,
    description: description.present ? description.value : this.description,
    startTime: startTime.present ? startTime.value : this.startTime,
    duration: duration.present ? duration.value : this.duration,
    isRepeating: isRepeating ?? this.isRepeating,
    tags: tags.present ? tags.value : this.tags,
    priority: priority ?? this.priority,
    reminders: reminders.present ? reminders.value : this.reminders,
    subTasks: subTasks.present ? subTasks.value : this.subTasks,
    deleted: deleted ?? this.deleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskInstanceEntry copyWithCompanion(TaskInstancesCompanion data) {
    return TaskInstanceEntry(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      rid: data.rid.present ? data.rid.value : this.rid,
      title: data.title.present ? data.title.value : this.title,
      completion: data.completion.present
          ? data.completion.value
          : this.completion,
      description: data.description.present
          ? data.description.value
          : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      isRepeating: data.isRepeating.present
          ? data.isRepeating.value
          : this.isRepeating,
      tags: data.tags.present ? data.tags.value : this.tags,
      priority: data.priority.present ? data.priority.value : this.priority,
      reminders: data.reminders.present ? data.reminders.value : this.reminders,
      subTasks: data.subTasks.present ? data.subTasks.value : this.subTasks,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskInstanceEntry(')
          ..write('taskId: $taskId, ')
          ..write('rid: $rid, ')
          ..write('title: $title, ')
          ..write('completion: $completion, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('duration: $duration, ')
          ..write('isRepeating: $isRepeating, ')
          ..write('tags: $tags, ')
          ..write('priority: $priority, ')
          ..write('reminders: $reminders, ')
          ..write('subTasks: $subTasks, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    rid,
    title,
    completion,
    description,
    startTime,
    duration,
    isRepeating,
    tags,
    priority,
    reminders,
    subTasks,
    deleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskInstanceEntry &&
          other.taskId == this.taskId &&
          other.rid == this.rid &&
          other.title == this.title &&
          other.completion == this.completion &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.duration == this.duration &&
          other.isRepeating == this.isRepeating &&
          other.tags == this.tags &&
          other.priority == this.priority &&
          other.reminders == this.reminders &&
          other.subTasks == this.subTasks &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskInstancesCompanion extends UpdateCompanion<TaskInstanceEntry> {
  final Value<String> taskId;
  final Value<DateTime?> rid;
  final Value<String> title;
  final Value<String> completion;
  final Value<String?> description;
  final Value<DateTime?> startTime;
  final Value<int?> duration;
  final Value<bool> isRepeating;
  final Value<String?> tags;
  final Value<int> priority;
  final Value<String?> reminders;
  final Value<String?> subTasks;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskInstancesCompanion({
    this.taskId = const Value.absent(),
    this.rid = const Value.absent(),
    this.title = const Value.absent(),
    this.completion = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.isRepeating = const Value.absent(),
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.reminders = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskInstancesCompanion.insert({
    required String taskId,
    this.rid = const Value.absent(),
    required String title,
    this.completion = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.isRepeating = const Value.absent(),
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.reminders = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       title = Value(title);
  static Insertable<TaskInstanceEntry> custom({
    Expression<String>? taskId,
    Expression<DateTime>? rid,
    Expression<String>? title,
    Expression<String>? completion,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<int>? duration,
    Expression<bool>? isRepeating,
    Expression<String>? tags,
    Expression<int>? priority,
    Expression<String>? reminders,
    Expression<String>? subTasks,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (rid != null) 'rid': rid,
      if (title != null) 'title': title,
      if (completion != null) 'completion': completion,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (duration != null) 'duration': duration,
      if (isRepeating != null) 'is_repeating': isRepeating,
      if (tags != null) 'tags': tags,
      if (priority != null) 'priority': priority,
      if (reminders != null) 'reminders': reminders,
      if (subTasks != null) 'sub_tasks': subTasks,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskInstancesCompanion copyWith({
    Value<String>? taskId,
    Value<DateTime?>? rid,
    Value<String>? title,
    Value<String>? completion,
    Value<String?>? description,
    Value<DateTime?>? startTime,
    Value<int?>? duration,
    Value<bool>? isRepeating,
    Value<String?>? tags,
    Value<int>? priority,
    Value<String?>? reminders,
    Value<String?>? subTasks,
    Value<bool>? deleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskInstancesCompanion(
      taskId: taskId ?? this.taskId,
      rid: rid ?? this.rid,
      title: title ?? this.title,
      completion: completion ?? this.completion,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      isRepeating: isRepeating ?? this.isRepeating,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      reminders: reminders ?? this.reminders,
      subTasks: subTasks ?? this.subTasks,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (rid.present) {
      map['rid'] = Variable<DateTime>(rid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completion.present) {
      map['completion'] = Variable<String>(completion.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (isRepeating.present) {
      map['is_repeating'] = Variable<bool>(isRepeating.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (reminders.present) {
      map['reminders'] = Variable<String>(reminders.value);
    }
    if (subTasks.present) {
      map['sub_tasks'] = Variable<String>(subTasks.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskInstancesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('rid: $rid, ')
          ..write('title: $title, ')
          ..write('completion: $completion, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('duration: $duration, ')
          ..write('isRepeating: $isRepeating, ')
          ..write('tags: $tags, ')
          ..write('priority: $priority, ')
          ..write('reminders: $reminders, ')
          ..write('subTasks: $subTasks, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskOverridesTable extends TaskOverrides
    with TableInfo<$TaskOverridesTable, TaskOverrideEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_patterns (id)',
    ),
  );
  static const VerificationMeta _ridMeta = const VerificationMeta('rid');
  @override
  late final GeneratedColumn<DateTime> rid = GeneratedColumn<DateTime>(
    'rid',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completionMeta = const VerificationMeta(
    'completion',
  );
  @override
  late final GeneratedColumn<String> completion = GeneratedColumn<String>(
    'completion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
    'duration',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rruleMeta = const VerificationMeta('rrule');
  @override
  late final GeneratedColumn<String> rrule = GeneratedColumn<String>(
    'rrule',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindersMeta = const VerificationMeta(
    'reminders',
  );
  @override
  late final GeneratedColumn<String> reminders = GeneratedColumn<String>(
    'reminders',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subTasksMeta = const VerificationMeta(
    'subTasks',
  );
  @override
  late final GeneratedColumn<String> subTasks = GeneratedColumn<String>(
    'sub_tasks',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    taskId,
    rid,
    title,
    completion,
    description,
    startTime,
    duration,
    rrule,
    tags,
    priority,
    reminders,
    subTasks,
    deleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskOverrideEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('rid')) {
      context.handle(
        _ridMeta,
        rid.isAcceptableOrUnknown(data['rid']!, _ridMeta),
      );
    } else if (isInserting) {
      context.missing(_ridMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('completion')) {
      context.handle(
        _completionMeta,
        completion.isAcceptableOrUnknown(data['completion']!, _completionMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    }
    if (data.containsKey('rrule')) {
      context.handle(
        _rruleMeta,
        rrule.isAcceptableOrUnknown(data['rrule']!, _rruleMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('reminders')) {
      context.handle(
        _remindersMeta,
        reminders.isAcceptableOrUnknown(data['reminders']!, _remindersMeta),
      );
    }
    if (data.containsKey('sub_tasks')) {
      context.handle(
        _subTasksMeta,
        subTasks.isAcceptableOrUnknown(data['sub_tasks']!, _subTasksMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, rid};
  @override
  TaskOverrideEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskOverrideEntry(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      rid: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}rid'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      completion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}completion'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      ),
      duration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration'],
      ),
      rrule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rrule'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      ),
      reminders: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminders'],
      ),
      subTasks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_tasks'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TaskOverridesTable createAlias(String alias) {
    return $TaskOverridesTable(attachedDatabase, alias);
  }
}

class TaskOverrideEntry extends DataClass
    implements Insertable<TaskOverrideEntry> {
  final String taskId;
  final DateTime rid;
  final String? title;
  final String? completion;
  final String? description;
  final DateTime? startTime;
  final int? duration;
  final String? rrule;
  final String? tags;
  final int? priority;
  final String? reminders;
  final String? subTasks;
  final bool? deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskOverrideEntry({
    required this.taskId,
    required this.rid,
    this.title,
    this.completion,
    this.description,
    this.startTime,
    this.duration,
    this.rrule,
    this.tags,
    this.priority,
    this.reminders,
    this.subTasks,
    this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['rid'] = Variable<DateTime>(rid);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || completion != null) {
      map['completion'] = Variable<String>(completion);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || rrule != null) {
      map['rrule'] = Variable<String>(rrule);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || reminders != null) {
      map['reminders'] = Variable<String>(reminders);
    }
    if (!nullToAbsent || subTasks != null) {
      map['sub_tasks'] = Variable<String>(subTasks);
    }
    if (!nullToAbsent || deleted != null) {
      map['deleted'] = Variable<bool>(deleted);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TaskOverridesCompanion toCompanion(bool nullToAbsent) {
    return TaskOverridesCompanion(
      taskId: Value(taskId),
      rid: Value(rid),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      completion: completion == null && nullToAbsent
          ? const Value.absent()
          : Value(completion),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      rrule: rrule == null && nullToAbsent
          ? const Value.absent()
          : Value(rrule),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      reminders: reminders == null && nullToAbsent
          ? const Value.absent()
          : Value(reminders),
      subTasks: subTasks == null && nullToAbsent
          ? const Value.absent()
          : Value(subTasks),
      deleted: deleted == null && nullToAbsent
          ? const Value.absent()
          : Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskOverrideEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskOverrideEntry(
      taskId: serializer.fromJson<String>(json['taskId']),
      rid: serializer.fromJson<DateTime>(json['rid']),
      title: serializer.fromJson<String?>(json['title']),
      completion: serializer.fromJson<String?>(json['completion']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      duration: serializer.fromJson<int?>(json['duration']),
      rrule: serializer.fromJson<String?>(json['rrule']),
      tags: serializer.fromJson<String?>(json['tags']),
      priority: serializer.fromJson<int?>(json['priority']),
      reminders: serializer.fromJson<String?>(json['reminders']),
      subTasks: serializer.fromJson<String?>(json['subTasks']),
      deleted: serializer.fromJson<bool?>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'rid': serializer.toJson<DateTime>(rid),
      'title': serializer.toJson<String?>(title),
      'completion': serializer.toJson<String?>(completion),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'duration': serializer.toJson<int?>(duration),
      'rrule': serializer.toJson<String?>(rrule),
      'tags': serializer.toJson<String?>(tags),
      'priority': serializer.toJson<int?>(priority),
      'reminders': serializer.toJson<String?>(reminders),
      'subTasks': serializer.toJson<String?>(subTasks),
      'deleted': serializer.toJson<bool?>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskOverrideEntry copyWith({
    String? taskId,
    DateTime? rid,
    Value<String?> title = const Value.absent(),
    Value<String?> completion = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<DateTime?> startTime = const Value.absent(),
    Value<int?> duration = const Value.absent(),
    Value<String?> rrule = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<int?> priority = const Value.absent(),
    Value<String?> reminders = const Value.absent(),
    Value<String?> subTasks = const Value.absent(),
    Value<bool?> deleted = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskOverrideEntry(
    taskId: taskId ?? this.taskId,
    rid: rid ?? this.rid,
    title: title.present ? title.value : this.title,
    completion: completion.present ? completion.value : this.completion,
    description: description.present ? description.value : this.description,
    startTime: startTime.present ? startTime.value : this.startTime,
    duration: duration.present ? duration.value : this.duration,
    rrule: rrule.present ? rrule.value : this.rrule,
    tags: tags.present ? tags.value : this.tags,
    priority: priority.present ? priority.value : this.priority,
    reminders: reminders.present ? reminders.value : this.reminders,
    subTasks: subTasks.present ? subTasks.value : this.subTasks,
    deleted: deleted.present ? deleted.value : this.deleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskOverrideEntry copyWithCompanion(TaskOverridesCompanion data) {
    return TaskOverrideEntry(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      rid: data.rid.present ? data.rid.value : this.rid,
      title: data.title.present ? data.title.value : this.title,
      completion: data.completion.present
          ? data.completion.value
          : this.completion,
      description: data.description.present
          ? data.description.value
          : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      duration: data.duration.present ? data.duration.value : this.duration,
      rrule: data.rrule.present ? data.rrule.value : this.rrule,
      tags: data.tags.present ? data.tags.value : this.tags,
      priority: data.priority.present ? data.priority.value : this.priority,
      reminders: data.reminders.present ? data.reminders.value : this.reminders,
      subTasks: data.subTasks.present ? data.subTasks.value : this.subTasks,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskOverrideEntry(')
          ..write('taskId: $taskId, ')
          ..write('rid: $rid, ')
          ..write('title: $title, ')
          ..write('completion: $completion, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('duration: $duration, ')
          ..write('rrule: $rrule, ')
          ..write('tags: $tags, ')
          ..write('priority: $priority, ')
          ..write('reminders: $reminders, ')
          ..write('subTasks: $subTasks, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    taskId,
    rid,
    title,
    completion,
    description,
    startTime,
    duration,
    rrule,
    tags,
    priority,
    reminders,
    subTasks,
    deleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskOverrideEntry &&
          other.taskId == this.taskId &&
          other.rid == this.rid &&
          other.title == this.title &&
          other.completion == this.completion &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.duration == this.duration &&
          other.rrule == this.rrule &&
          other.tags == this.tags &&
          other.priority == this.priority &&
          other.reminders == this.reminders &&
          other.subTasks == this.subTasks &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TaskOverridesCompanion extends UpdateCompanion<TaskOverrideEntry> {
  final Value<String> taskId;
  final Value<DateTime> rid;
  final Value<String?> title;
  final Value<String?> completion;
  final Value<String?> description;
  final Value<DateTime?> startTime;
  final Value<int?> duration;
  final Value<String?> rrule;
  final Value<String?> tags;
  final Value<int?> priority;
  final Value<String?> reminders;
  final Value<String?> subTasks;
  final Value<bool?> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TaskOverridesCompanion({
    this.taskId = const Value.absent(),
    this.rid = const Value.absent(),
    this.title = const Value.absent(),
    this.completion = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.rrule = const Value.absent(),
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.reminders = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskOverridesCompanion.insert({
    required String taskId,
    required DateTime rid,
    this.title = const Value.absent(),
    this.completion = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.duration = const Value.absent(),
    this.rrule = const Value.absent(),
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.reminders = const Value.absent(),
    this.subTasks = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       rid = Value(rid);
  static Insertable<TaskOverrideEntry> custom({
    Expression<String>? taskId,
    Expression<DateTime>? rid,
    Expression<String>? title,
    Expression<String>? completion,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<int>? duration,
    Expression<String>? rrule,
    Expression<String>? tags,
    Expression<int>? priority,
    Expression<String>? reminders,
    Expression<String>? subTasks,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (rid != null) 'rid': rid,
      if (title != null) 'title': title,
      if (completion != null) 'completion': completion,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (duration != null) 'duration': duration,
      if (rrule != null) 'rrule': rrule,
      if (tags != null) 'tags': tags,
      if (priority != null) 'priority': priority,
      if (reminders != null) 'reminders': reminders,
      if (subTasks != null) 'sub_tasks': subTasks,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskOverridesCompanion copyWith({
    Value<String>? taskId,
    Value<DateTime>? rid,
    Value<String?>? title,
    Value<String?>? completion,
    Value<String?>? description,
    Value<DateTime?>? startTime,
    Value<int?>? duration,
    Value<String?>? rrule,
    Value<String?>? tags,
    Value<int?>? priority,
    Value<String?>? reminders,
    Value<String?>? subTasks,
    Value<bool?>? deleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TaskOverridesCompanion(
      taskId: taskId ?? this.taskId,
      rid: rid ?? this.rid,
      title: title ?? this.title,
      completion: completion ?? this.completion,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      rrule: rrule ?? this.rrule,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      reminders: reminders ?? this.reminders,
      subTasks: subTasks ?? this.subTasks,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (rid.present) {
      map['rid'] = Variable<DateTime>(rid.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completion.present) {
      map['completion'] = Variable<String>(completion.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (rrule.present) {
      map['rrule'] = Variable<String>(rrule.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (reminders.present) {
      map['reminders'] = Variable<String>(reminders.value);
    }
    if (subTasks.present) {
      map['sub_tasks'] = Variable<String>(subTasks.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskOverridesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('rid: $rid, ')
          ..write('title: $title, ')
          ..write('completion: $completion, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('duration: $duration, ')
          ..write('rrule: $rrule, ')
          ..write('tags: $tags, ')
          ..write('priority: $priority, ')
          ..write('reminders: $reminders, ')
          ..write('subTasks: $subTasks, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MaterializationStatesTable extends MaterializationStates
    with TableInfo<$MaterializationStatesTable, MaterializationStateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MaterializationStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastRevMeta = const VerificationMeta(
    'lastRev',
  );
  @override
  late final GeneratedColumn<int> lastRev = GeneratedColumn<int>(
    'last_rev',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowFromMeta = const VerificationMeta(
    'windowFrom',
  );
  @override
  late final GeneratedColumn<DateTime> windowFrom = GeneratedColumn<DateTime>(
    'window_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowToMeta = const VerificationMeta(
    'windowTo',
  );
  @override
  late final GeneratedColumn<DateTime> windowTo = GeneratedColumn<DateTime>(
    'window_to',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, lastRev, windowFrom, windowTo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'materialization_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<MaterializationStateEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('last_rev')) {
      context.handle(
        _lastRevMeta,
        lastRev.isAcceptableOrUnknown(data['last_rev']!, _lastRevMeta),
      );
    } else if (isInserting) {
      context.missing(_lastRevMeta);
    }
    if (data.containsKey('window_from')) {
      context.handle(
        _windowFromMeta,
        windowFrom.isAcceptableOrUnknown(data['window_from']!, _windowFromMeta),
      );
    } else if (isInserting) {
      context.missing(_windowFromMeta);
    }
    if (data.containsKey('window_to')) {
      context.handle(
        _windowToMeta,
        windowTo.isAcceptableOrUnknown(data['window_to']!, _windowToMeta),
      );
    } else if (isInserting) {
      context.missing(_windowToMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId};
  @override
  MaterializationStateEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MaterializationStateEntry(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      lastRev: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_rev'],
      )!,
      windowFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}window_from'],
      )!,
      windowTo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}window_to'],
      )!,
    );
  }

  @override
  $MaterializationStatesTable createAlias(String alias) {
    return $MaterializationStatesTable(attachedDatabase, alias);
  }
}

class MaterializationStateEntry extends DataClass
    implements Insertable<MaterializationStateEntry> {
  final String taskId;
  final int lastRev;
  final DateTime windowFrom;
  final DateTime windowTo;
  const MaterializationStateEntry({
    required this.taskId,
    required this.lastRev,
    required this.windowFrom,
    required this.windowTo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['last_rev'] = Variable<int>(lastRev);
    map['window_from'] = Variable<DateTime>(windowFrom);
    map['window_to'] = Variable<DateTime>(windowTo);
    return map;
  }

  MaterializationStatesCompanion toCompanion(bool nullToAbsent) {
    return MaterializationStatesCompanion(
      taskId: Value(taskId),
      lastRev: Value(lastRev),
      windowFrom: Value(windowFrom),
      windowTo: Value(windowTo),
    );
  }

  factory MaterializationStateEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MaterializationStateEntry(
      taskId: serializer.fromJson<String>(json['taskId']),
      lastRev: serializer.fromJson<int>(json['lastRev']),
      windowFrom: serializer.fromJson<DateTime>(json['windowFrom']),
      windowTo: serializer.fromJson<DateTime>(json['windowTo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'lastRev': serializer.toJson<int>(lastRev),
      'windowFrom': serializer.toJson<DateTime>(windowFrom),
      'windowTo': serializer.toJson<DateTime>(windowTo),
    };
  }

  MaterializationStateEntry copyWith({
    String? taskId,
    int? lastRev,
    DateTime? windowFrom,
    DateTime? windowTo,
  }) => MaterializationStateEntry(
    taskId: taskId ?? this.taskId,
    lastRev: lastRev ?? this.lastRev,
    windowFrom: windowFrom ?? this.windowFrom,
    windowTo: windowTo ?? this.windowTo,
  );
  MaterializationStateEntry copyWithCompanion(
    MaterializationStatesCompanion data,
  ) {
    return MaterializationStateEntry(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      lastRev: data.lastRev.present ? data.lastRev.value : this.lastRev,
      windowFrom: data.windowFrom.present
          ? data.windowFrom.value
          : this.windowFrom,
      windowTo: data.windowTo.present ? data.windowTo.value : this.windowTo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MaterializationStateEntry(')
          ..write('taskId: $taskId, ')
          ..write('lastRev: $lastRev, ')
          ..write('windowFrom: $windowFrom, ')
          ..write('windowTo: $windowTo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, lastRev, windowFrom, windowTo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MaterializationStateEntry &&
          other.taskId == this.taskId &&
          other.lastRev == this.lastRev &&
          other.windowFrom == this.windowFrom &&
          other.windowTo == this.windowTo);
}

class MaterializationStatesCompanion
    extends UpdateCompanion<MaterializationStateEntry> {
  final Value<String> taskId;
  final Value<int> lastRev;
  final Value<DateTime> windowFrom;
  final Value<DateTime> windowTo;
  final Value<int> rowid;
  const MaterializationStatesCompanion({
    this.taskId = const Value.absent(),
    this.lastRev = const Value.absent(),
    this.windowFrom = const Value.absent(),
    this.windowTo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MaterializationStatesCompanion.insert({
    required String taskId,
    required int lastRev,
    required DateTime windowFrom,
    required DateTime windowTo,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       lastRev = Value(lastRev),
       windowFrom = Value(windowFrom),
       windowTo = Value(windowTo);
  static Insertable<MaterializationStateEntry> custom({
    Expression<String>? taskId,
    Expression<int>? lastRev,
    Expression<DateTime>? windowFrom,
    Expression<DateTime>? windowTo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (lastRev != null) 'last_rev': lastRev,
      if (windowFrom != null) 'window_from': windowFrom,
      if (windowTo != null) 'window_to': windowTo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MaterializationStatesCompanion copyWith({
    Value<String>? taskId,
    Value<int>? lastRev,
    Value<DateTime>? windowFrom,
    Value<DateTime>? windowTo,
    Value<int>? rowid,
  }) {
    return MaterializationStatesCompanion(
      taskId: taskId ?? this.taskId,
      lastRev: lastRev ?? this.lastRev,
      windowFrom: windowFrom ?? this.windowFrom,
      windowTo: windowTo ?? this.windowTo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (lastRev.present) {
      map['last_rev'] = Variable<int>(lastRev.value);
    }
    if (windowFrom.present) {
      map['window_from'] = Variable<DateTime>(windowFrom.value);
    }
    if (windowTo.present) {
      map['window_to'] = Variable<DateTime>(windowTo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MaterializationStatesCompanion(')
          ..write('taskId: $taskId, ')
          ..write('lastRev: $lastRev, ')
          ..write('windowFrom: $windowFrom, ')
          ..write('windowTo: $windowTo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDB extends GeneratedDatabase {
  _$LocalDB(QueryExecutor e) : super(e);
  $LocalDBManager get managers => $LocalDBManager(this);
  late final $TaskPatternsTable taskPatterns = $TaskPatternsTable(this);
  late final $TaskInstancesTable taskInstances = $TaskInstancesTable(this);
  late final $TaskOverridesTable taskOverrides = $TaskOverridesTable(this);
  late final $MaterializationStatesTable materializationStates =
      $MaterializationStatesTable(this);
  late final Index ridIndex = Index(
    'rid_index',
    'CREATE INDEX rid_index ON task_instances (start_time)',
  );
  late final TaskInstanceDao taskInstanceDao = TaskInstanceDao(this as LocalDB);
  late final TaskPatternDao taskPatternDao = TaskPatternDao(this as LocalDB);
  late final TaskOverrideDao taskOverrideDao = TaskOverrideDao(this as LocalDB);
  late final MaterializationStateDao materializationStateDao =
      MaterializationStateDao(this as LocalDB);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskPatterns,
    taskInstances,
    taskOverrides,
    materializationStates,
    ridIndex,
  ];
}

typedef $$TaskPatternsTableCreateCompanionBuilder =
    TaskPatternsCompanion Function({
      required String id,
      required String title,
      Value<String> completion,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<int?> duration,
      Value<String?> rrule,
      Value<String?> rdates,
      Value<String?> exdates,
      Value<String?> tags,
      Value<int> priority,
      Value<String?> reminders,
      Value<String?> subTasks,
      Value<bool> deleted,
      Value<int> rev,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskPatternsTableUpdateCompanionBuilder =
    TaskPatternsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> completion,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<int?> duration,
      Value<String?> rrule,
      Value<String?> rdates,
      Value<String?> exdates,
      Value<String?> tags,
      Value<int> priority,
      Value<String?> reminders,
      Value<String?> subTasks,
      Value<bool> deleted,
      Value<int> rev,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskPatternsTableReferences
    extends BaseReferences<_$LocalDB, $TaskPatternsTable, TaskPatternEntry> {
  $$TaskPatternsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TaskInstancesTable, List<TaskInstanceEntry>>
  _taskInstancesRefsTable(_$LocalDB db) => MultiTypedResultKey.fromTable(
    db.taskInstances,
    aliasName: $_aliasNameGenerator(
      db.taskPatterns.id,
      db.taskInstances.taskId,
    ),
  );

  $$TaskInstancesTableProcessedTableManager get taskInstancesRefs {
    final manager = $$TaskInstancesTableTableManager(
      $_db,
      $_db.taskInstances,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskInstancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskOverridesTable, List<TaskOverrideEntry>>
  _taskOverridesRefsTable(_$LocalDB db) => MultiTypedResultKey.fromTable(
    db.taskOverrides,
    aliasName: $_aliasNameGenerator(
      db.taskPatterns.id,
      db.taskOverrides.taskId,
    ),
  );

  $$TaskOverridesTableProcessedTableManager get taskOverridesRefs {
    final manager = $$TaskOverridesTableTableManager(
      $_db,
      $_db.taskOverrides,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskOverridesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskPatternsTableFilterComposer
    extends Composer<_$LocalDB, $TaskPatternsTable> {
  $$TaskPatternsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rdates => $composableBuilder(
    column: $table.rdates,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exdates => $composableBuilder(
    column: $table.exdates,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subTasks => $composableBuilder(
    column: $table.subTasks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> taskInstancesRefs(
    Expression<bool> Function($$TaskInstancesTableFilterComposer f) f,
  ) {
    final $$TaskInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskInstances,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskInstancesTableFilterComposer(
            $db: $db,
            $table: $db.taskInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskOverridesRefs(
    Expression<bool> Function($$TaskOverridesTableFilterComposer f) f,
  ) {
    final $$TaskOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskOverrides,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskOverridesTableFilterComposer(
            $db: $db,
            $table: $db.taskOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskPatternsTableOrderingComposer
    extends Composer<_$LocalDB, $TaskPatternsTable> {
  $$TaskPatternsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rdates => $composableBuilder(
    column: $table.rdates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exdates => $composableBuilder(
    column: $table.exdates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subTasks => $composableBuilder(
    column: $table.subTasks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rev => $composableBuilder(
    column: $table.rev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskPatternsTableAnnotationComposer
    extends Composer<_$LocalDB, $TaskPatternsTable> {
  $$TaskPatternsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get rrule =>
      $composableBuilder(column: $table.rrule, builder: (column) => column);

  GeneratedColumn<String> get rdates =>
      $composableBuilder(column: $table.rdates, builder: (column) => column);

  GeneratedColumn<String> get exdates =>
      $composableBuilder(column: $table.exdates, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get reminders =>
      $composableBuilder(column: $table.reminders, builder: (column) => column);

  GeneratedColumn<String> get subTasks =>
      $composableBuilder(column: $table.subTasks, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get rev =>
      $composableBuilder(column: $table.rev, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> taskInstancesRefs<T extends Object>(
    Expression<T> Function($$TaskInstancesTableAnnotationComposer a) f,
  ) {
    final $$TaskInstancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskInstances,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskInstancesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskOverridesRefs<T extends Object>(
    Expression<T> Function($$TaskOverridesTableAnnotationComposer a) f,
  ) {
    final $$TaskOverridesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskOverrides,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskOverridesTableAnnotationComposer(
            $db: $db,
            $table: $db.taskOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskPatternsTableTableManager
    extends
        RootTableManager<
          _$LocalDB,
          $TaskPatternsTable,
          TaskPatternEntry,
          $$TaskPatternsTableFilterComposer,
          $$TaskPatternsTableOrderingComposer,
          $$TaskPatternsTableAnnotationComposer,
          $$TaskPatternsTableCreateCompanionBuilder,
          $$TaskPatternsTableUpdateCompanionBuilder,
          (TaskPatternEntry, $$TaskPatternsTableReferences),
          TaskPatternEntry,
          PrefetchHooks Function({
            bool taskInstancesRefs,
            bool taskOverridesRefs,
          })
        > {
  $$TaskPatternsTableTableManager(_$LocalDB db, $TaskPatternsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskPatternsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskPatternsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskPatternsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> completion = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> rdates = const Value.absent(),
                Value<String?> exdates = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> reminders = const Value.absent(),
                Value<String?> subTasks = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskPatternsCompanion(
                id: id,
                title: title,
                completion: completion,
                description: description,
                startTime: startTime,
                duration: duration,
                rrule: rrule,
                rdates: rdates,
                exdates: exdates,
                tags: tags,
                priority: priority,
                reminders: reminders,
                subTasks: subTasks,
                deleted: deleted,
                rev: rev,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> completion = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> rdates = const Value.absent(),
                Value<String?> exdates = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> reminders = const Value.absent(),
                Value<String?> subTasks = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rev = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskPatternsCompanion.insert(
                id: id,
                title: title,
                completion: completion,
                description: description,
                startTime: startTime,
                duration: duration,
                rrule: rrule,
                rdates: rdates,
                exdates: exdates,
                tags: tags,
                priority: priority,
                reminders: reminders,
                subTasks: subTasks,
                deleted: deleted,
                rev: rev,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskPatternsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({taskInstancesRefs = false, taskOverridesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskInstancesRefs) db.taskInstances,
                    if (taskOverridesRefs) db.taskOverrides,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskInstancesRefs)
                        await $_getPrefetchedData<
                          TaskPatternEntry,
                          $TaskPatternsTable,
                          TaskInstanceEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TaskPatternsTableReferences
                              ._taskInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskPatternsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskInstancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskOverridesRefs)
                        await $_getPrefetchedData<
                          TaskPatternEntry,
                          $TaskPatternsTable,
                          TaskOverrideEntry
                        >(
                          currentTable: table,
                          referencedTable: $$TaskPatternsTableReferences
                              ._taskOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskPatternsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskOverridesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TaskPatternsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDB,
      $TaskPatternsTable,
      TaskPatternEntry,
      $$TaskPatternsTableFilterComposer,
      $$TaskPatternsTableOrderingComposer,
      $$TaskPatternsTableAnnotationComposer,
      $$TaskPatternsTableCreateCompanionBuilder,
      $$TaskPatternsTableUpdateCompanionBuilder,
      (TaskPatternEntry, $$TaskPatternsTableReferences),
      TaskPatternEntry,
      PrefetchHooks Function({bool taskInstancesRefs, bool taskOverridesRefs})
    >;
typedef $$TaskInstancesTableCreateCompanionBuilder =
    TaskInstancesCompanion Function({
      required String taskId,
      Value<DateTime?> rid,
      required String title,
      Value<String> completion,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<int?> duration,
      Value<bool> isRepeating,
      Value<String?> tags,
      Value<int> priority,
      Value<String?> reminders,
      Value<String?> subTasks,
      Value<bool> deleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskInstancesTableUpdateCompanionBuilder =
    TaskInstancesCompanion Function({
      Value<String> taskId,
      Value<DateTime?> rid,
      Value<String> title,
      Value<String> completion,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<int?> duration,
      Value<bool> isRepeating,
      Value<String?> tags,
      Value<int> priority,
      Value<String?> reminders,
      Value<String?> subTasks,
      Value<bool> deleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskInstancesTableReferences
    extends BaseReferences<_$LocalDB, $TaskInstancesTable, TaskInstanceEntry> {
  $$TaskInstancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskPatternsTable _taskIdTable(_$LocalDB db) =>
      db.taskPatterns.createAlias(
        $_aliasNameGenerator(db.taskInstances.taskId, db.taskPatterns.id),
      );

  $$TaskPatternsTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TaskPatternsTableTableManager(
      $_db,
      $_db.taskPatterns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskInstancesTableFilterComposer
    extends Composer<_$LocalDB, $TaskInstancesTable> {
  $$TaskInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get rid => $composableBuilder(
    column: $table.rid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRepeating => $composableBuilder(
    column: $table.isRepeating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subTasks => $composableBuilder(
    column: $table.subTasks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskPatternsTableFilterComposer get taskId {
    final $$TaskPatternsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskPatterns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskPatternsTableFilterComposer(
            $db: $db,
            $table: $db.taskPatterns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskInstancesTableOrderingComposer
    extends Composer<_$LocalDB, $TaskInstancesTable> {
  $$TaskInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get rid => $composableBuilder(
    column: $table.rid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRepeating => $composableBuilder(
    column: $table.isRepeating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subTasks => $composableBuilder(
    column: $table.subTasks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskPatternsTableOrderingComposer get taskId {
    final $$TaskPatternsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskPatterns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskPatternsTableOrderingComposer(
            $db: $db,
            $table: $db.taskPatterns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskInstancesTableAnnotationComposer
    extends Composer<_$LocalDB, $TaskInstancesTable> {
  $$TaskInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get rid =>
      $composableBuilder(column: $table.rid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get isRepeating => $composableBuilder(
    column: $table.isRepeating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get reminders =>
      $composableBuilder(column: $table.reminders, builder: (column) => column);

  GeneratedColumn<String> get subTasks =>
      $composableBuilder(column: $table.subTasks, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TaskPatternsTableAnnotationComposer get taskId {
    final $$TaskPatternsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskPatterns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskPatternsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskPatterns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskInstancesTableTableManager
    extends
        RootTableManager<
          _$LocalDB,
          $TaskInstancesTable,
          TaskInstanceEntry,
          $$TaskInstancesTableFilterComposer,
          $$TaskInstancesTableOrderingComposer,
          $$TaskInstancesTableAnnotationComposer,
          $$TaskInstancesTableCreateCompanionBuilder,
          $$TaskInstancesTableUpdateCompanionBuilder,
          (TaskInstanceEntry, $$TaskInstancesTableReferences),
          TaskInstanceEntry,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskInstancesTableTableManager(_$LocalDB db, $TaskInstancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskInstancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<DateTime?> rid = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> completion = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<bool> isRepeating = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> reminders = const Value.absent(),
                Value<String?> subTasks = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskInstancesCompanion(
                taskId: taskId,
                rid: rid,
                title: title,
                completion: completion,
                description: description,
                startTime: startTime,
                duration: duration,
                isRepeating: isRepeating,
                tags: tags,
                priority: priority,
                reminders: reminders,
                subTasks: subTasks,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                Value<DateTime?> rid = const Value.absent(),
                required String title,
                Value<String> completion = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<bool> isRepeating = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<String?> reminders = const Value.absent(),
                Value<String?> subTasks = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskInstancesCompanion.insert(
                taskId: taskId,
                rid: rid,
                title: title,
                completion: completion,
                description: description,
                startTime: startTime,
                duration: duration,
                isRepeating: isRepeating,
                tags: tags,
                priority: priority,
                reminders: reminders,
                subTasks: subTasks,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskInstancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskInstancesTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$TaskInstancesTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDB,
      $TaskInstancesTable,
      TaskInstanceEntry,
      $$TaskInstancesTableFilterComposer,
      $$TaskInstancesTableOrderingComposer,
      $$TaskInstancesTableAnnotationComposer,
      $$TaskInstancesTableCreateCompanionBuilder,
      $$TaskInstancesTableUpdateCompanionBuilder,
      (TaskInstanceEntry, $$TaskInstancesTableReferences),
      TaskInstanceEntry,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$TaskOverridesTableCreateCompanionBuilder =
    TaskOverridesCompanion Function({
      required String taskId,
      required DateTime rid,
      Value<String?> title,
      Value<String?> completion,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<int?> duration,
      Value<String?> rrule,
      Value<String?> tags,
      Value<int?> priority,
      Value<String?> reminders,
      Value<String?> subTasks,
      Value<bool?> deleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TaskOverridesTableUpdateCompanionBuilder =
    TaskOverridesCompanion Function({
      Value<String> taskId,
      Value<DateTime> rid,
      Value<String?> title,
      Value<String?> completion,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<int?> duration,
      Value<String?> rrule,
      Value<String?> tags,
      Value<int?> priority,
      Value<String?> reminders,
      Value<String?> subTasks,
      Value<bool?> deleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TaskOverridesTableReferences
    extends BaseReferences<_$LocalDB, $TaskOverridesTable, TaskOverrideEntry> {
  $$TaskOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskPatternsTable _taskIdTable(_$LocalDB db) =>
      db.taskPatterns.createAlias(
        $_aliasNameGenerator(db.taskOverrides.taskId, db.taskPatterns.id),
      );

  $$TaskPatternsTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TaskPatternsTableTableManager(
      $_db,
      $_db.taskPatterns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskOverridesTableFilterComposer
    extends Composer<_$LocalDB, $TaskOverridesTable> {
  $$TaskOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get rid => $composableBuilder(
    column: $table.rid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subTasks => $composableBuilder(
    column: $table.subTasks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskPatternsTableFilterComposer get taskId {
    final $$TaskPatternsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskPatterns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskPatternsTableFilterComposer(
            $db: $db,
            $table: $db.taskPatterns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskOverridesTableOrderingComposer
    extends Composer<_$LocalDB, $TaskOverridesTable> {
  $$TaskOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get rid => $composableBuilder(
    column: $table.rid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rrule => $composableBuilder(
    column: $table.rrule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminders => $composableBuilder(
    column: $table.reminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subTasks => $composableBuilder(
    column: $table.subTasks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskPatternsTableOrderingComposer get taskId {
    final $$TaskPatternsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskPatterns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskPatternsTableOrderingComposer(
            $db: $db,
            $table: $db.taskPatterns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskOverridesTableAnnotationComposer
    extends Composer<_$LocalDB, $TaskOverridesTable> {
  $$TaskOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get rid =>
      $composableBuilder(column: $table.rid, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get completion => $composableBuilder(
    column: $table.completion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get rrule =>
      $composableBuilder(column: $table.rrule, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get reminders =>
      $composableBuilder(column: $table.reminders, builder: (column) => column);

  GeneratedColumn<String> get subTasks =>
      $composableBuilder(column: $table.subTasks, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TaskPatternsTableAnnotationComposer get taskId {
    final $$TaskPatternsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.taskPatterns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskPatternsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskPatterns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskOverridesTableTableManager
    extends
        RootTableManager<
          _$LocalDB,
          $TaskOverridesTable,
          TaskOverrideEntry,
          $$TaskOverridesTableFilterComposer,
          $$TaskOverridesTableOrderingComposer,
          $$TaskOverridesTableAnnotationComposer,
          $$TaskOverridesTableCreateCompanionBuilder,
          $$TaskOverridesTableUpdateCompanionBuilder,
          (TaskOverrideEntry, $$TaskOverridesTableReferences),
          TaskOverrideEntry,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskOverridesTableTableManager(_$LocalDB db, $TaskOverridesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<DateTime> rid = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> completion = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<String?> reminders = const Value.absent(),
                Value<String?> subTasks = const Value.absent(),
                Value<bool?> deleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskOverridesCompanion(
                taskId: taskId,
                rid: rid,
                title: title,
                completion: completion,
                description: description,
                startTime: startTime,
                duration: duration,
                rrule: rrule,
                tags: tags,
                priority: priority,
                reminders: reminders,
                subTasks: subTasks,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required DateTime rid,
                Value<String?> title = const Value.absent(),
                Value<String?> completion = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<int?> duration = const Value.absent(),
                Value<String?> rrule = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<String?> reminders = const Value.absent(),
                Value<String?> subTasks = const Value.absent(),
                Value<bool?> deleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskOverridesCompanion.insert(
                taskId: taskId,
                rid: rid,
                title: title,
                completion: completion,
                description: description,
                startTime: startTime,
                duration: duration,
                rrule: rrule,
                tags: tags,
                priority: priority,
                reminders: reminders,
                subTasks: subTasks,
                deleted: deleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskOverridesTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$TaskOverridesTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDB,
      $TaskOverridesTable,
      TaskOverrideEntry,
      $$TaskOverridesTableFilterComposer,
      $$TaskOverridesTableOrderingComposer,
      $$TaskOverridesTableAnnotationComposer,
      $$TaskOverridesTableCreateCompanionBuilder,
      $$TaskOverridesTableUpdateCompanionBuilder,
      (TaskOverrideEntry, $$TaskOverridesTableReferences),
      TaskOverrideEntry,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$MaterializationStatesTableCreateCompanionBuilder =
    MaterializationStatesCompanion Function({
      required String taskId,
      required int lastRev,
      required DateTime windowFrom,
      required DateTime windowTo,
      Value<int> rowid,
    });
typedef $$MaterializationStatesTableUpdateCompanionBuilder =
    MaterializationStatesCompanion Function({
      Value<String> taskId,
      Value<int> lastRev,
      Value<DateTime> windowFrom,
      Value<DateTime> windowTo,
      Value<int> rowid,
    });

class $$MaterializationStatesTableFilterComposer
    extends Composer<_$LocalDB, $MaterializationStatesTable> {
  $$MaterializationStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastRev => $composableBuilder(
    column: $table.lastRev,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get windowFrom => $composableBuilder(
    column: $table.windowFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get windowTo => $composableBuilder(
    column: $table.windowTo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MaterializationStatesTableOrderingComposer
    extends Composer<_$LocalDB, $MaterializationStatesTable> {
  $$MaterializationStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastRev => $composableBuilder(
    column: $table.lastRev,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get windowFrom => $composableBuilder(
    column: $table.windowFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get windowTo => $composableBuilder(
    column: $table.windowTo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MaterializationStatesTableAnnotationComposer
    extends Composer<_$LocalDB, $MaterializationStatesTable> {
  $$MaterializationStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<int> get lastRev =>
      $composableBuilder(column: $table.lastRev, builder: (column) => column);

  GeneratedColumn<DateTime> get windowFrom => $composableBuilder(
    column: $table.windowFrom,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get windowTo =>
      $composableBuilder(column: $table.windowTo, builder: (column) => column);
}

class $$MaterializationStatesTableTableManager
    extends
        RootTableManager<
          _$LocalDB,
          $MaterializationStatesTable,
          MaterializationStateEntry,
          $$MaterializationStatesTableFilterComposer,
          $$MaterializationStatesTableOrderingComposer,
          $$MaterializationStatesTableAnnotationComposer,
          $$MaterializationStatesTableCreateCompanionBuilder,
          $$MaterializationStatesTableUpdateCompanionBuilder,
          (
            MaterializationStateEntry,
            BaseReferences<
              _$LocalDB,
              $MaterializationStatesTable,
              MaterializationStateEntry
            >,
          ),
          MaterializationStateEntry,
          PrefetchHooks Function()
        > {
  $$MaterializationStatesTableTableManager(
    _$LocalDB db,
    $MaterializationStatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MaterializationStatesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MaterializationStatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MaterializationStatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<int> lastRev = const Value.absent(),
                Value<DateTime> windowFrom = const Value.absent(),
                Value<DateTime> windowTo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MaterializationStatesCompanion(
                taskId: taskId,
                lastRev: lastRev,
                windowFrom: windowFrom,
                windowTo: windowTo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required int lastRev,
                required DateTime windowFrom,
                required DateTime windowTo,
                Value<int> rowid = const Value.absent(),
              }) => MaterializationStatesCompanion.insert(
                taskId: taskId,
                lastRev: lastRev,
                windowFrom: windowFrom,
                windowTo: windowTo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MaterializationStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDB,
      $MaterializationStatesTable,
      MaterializationStateEntry,
      $$MaterializationStatesTableFilterComposer,
      $$MaterializationStatesTableOrderingComposer,
      $$MaterializationStatesTableAnnotationComposer,
      $$MaterializationStatesTableCreateCompanionBuilder,
      $$MaterializationStatesTableUpdateCompanionBuilder,
      (
        MaterializationStateEntry,
        BaseReferences<
          _$LocalDB,
          $MaterializationStatesTable,
          MaterializationStateEntry
        >,
      ),
      MaterializationStateEntry,
      PrefetchHooks Function()
    >;

class $LocalDBManager {
  final _$LocalDB _db;
  $LocalDBManager(this._db);
  $$TaskPatternsTableTableManager get taskPatterns =>
      $$TaskPatternsTableTableManager(_db, _db.taskPatterns);
  $$TaskInstancesTableTableManager get taskInstances =>
      $$TaskInstancesTableTableManager(_db, _db.taskInstances);
  $$TaskOverridesTableTableManager get taskOverrides =>
      $$TaskOverridesTableTableManager(_db, _db.taskOverrides);
  $$MaterializationStatesTableTableManager get materializationStates =>
      $$MaterializationStatesTableTableManager(_db, _db.materializationStates);
}
