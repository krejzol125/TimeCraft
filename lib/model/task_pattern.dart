import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/noti_reminder.dart';
import 'package:rrule/rrule.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/repo/drift/local_db.dart';

class TaskPattern {
  String id;
  String title;
  Completion completion;

  String description;

  DateTime? startTime;
  Duration? duration;
  DateTime? get endTime => (startTime != null && duration != null)
      ? startTime!.add(duration!)
      : null;
  RecurrenceRule? rrule;

  List<String> tags;
  int priority;
  List<NotiReminder> reminders;
  List<String> subTasks;

  bool deleted = false;
  int rev = 0;

  DateTime createdAt;
  DateTime updatedAt;

  TaskPattern({
    required this.id,
    required this.title,
    Completion? completion,
    this.description = '',
    this.startTime,
    this.duration,
    this.rrule,
    this.tags = const [],
    this.priority = 3,
    this.reminders = const [],
    this.subTasks = const [],
    this.deleted = false,
    this.rev = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       completion = completion ?? BinaryCompletion(false);

  TaskPattern copyWith({
    String? id,
    String? title,
    Completion? completion,
    String? description,
    DateTime? startTime,
    Duration? duration,
    RecurrenceRule? rrule,
    List<String>? tags,
    int? priority,
    List<NotiReminder>? reminders,
    List<String>? subTasks,
    bool? deleted,
    int? rev,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskPattern(
      id: id ?? this.id,
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
      rev: rev ?? this.rev,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  TaskPattern.fromEntry(TaskPatternEntry entry)
    : id = entry.id,
      title = entry.title,
      completion = Completion.fromJson(entry.completion)!,
      description = entry.description ?? '',
      startTime = entry.startTime?.toLocal(),
      duration = entry.duration != null
          ? Duration(milliseconds: entry.duration!)
          : null,
      rrule = entry.rrule != null
          ? RecurrenceRule.fromString(entry.rrule!)
          : null,
      tags = entry.tags != null && entry.tags!.isNotEmpty
          ? entry.tags!.split(';')
          : [],
      priority = entry.priority,
      reminders = entry.reminders != null && entry.reminders!.isNotEmpty
          ? entry.reminders!
                .split(';')
                .map((e) => NotiReminder.fromJson(e)!)
                .toList()
          : [],
      subTasks = entry.subTasks != null && entry.subTasks!.isNotEmpty
          ? entry.subTasks!.split(';')
          : [],
      deleted = entry.deleted,
      rev = entry.rev,
      createdAt = entry.createdAt.toLocal(),
      updatedAt = entry.updatedAt.toLocal();

  TaskOverride differenceFrom(TaskPattern pattern, DateTime rid) {
    return TaskOverride(
      taskId: id,
      rid: rid,
      title: title != pattern.title ? title : null,
      completion: completion != pattern.completion ? completion : null,
      description: description != pattern.description ? description : null,
      startTime: startTime != pattern.startTime ? startTime : null,
      duration: duration != pattern.duration ? duration : null,
      tags: tags != pattern.tags ? tags : null,
      priority: priority != pattern.priority ? priority : null,
      reminders: reminders != pattern.reminders ? reminders : null,
      subTasks: subTasks != pattern.subTasks
          ? subTasks.map((e) => (e, false)).toList()
          : null,
      deleted: deleted != pattern.deleted ? deleted : false,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  TaskPatternsCompanion toCompanion() {
    return TaskPatternsCompanion(
      id: Value(id),
      title: Value(title),
      completion: Value(completion.toJson()),
      description: Value(description.isNotEmpty ? description : null),
      startTime: Value(startTime?.toUtc()),
      duration: Value(duration?.inMilliseconds),
      rrule: Value(rrule?.toString()),
      tags: Value(tags.isNotEmpty ? tags.join(';') : null),
      priority: Value(priority),
      reminders: Value(
        reminders.isNotEmpty
            ? reminders.map((e) => e.toJson()).join(';')
            : null,
      ),
      subTasks: Value(subTasks.isNotEmpty ? subTasks.join(';') : null),
      deleted: Value(deleted),
      rev: Value(rev),
      createdAt: Value(createdAt.toUtc()),
      updatedAt: Value(updatedAt.toUtc()),
    );
  }

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'completion': completion.toJson(),
    'description': description,
    'startTime': startTime?.toUtc().toIso8601String(),
    'duration': duration?.inMilliseconds,
    'rrule': rrule?.toString(),
    'tags': tags.join(';'),
    'priority': priority,
    'reminders': reminders.map((e) => e.toJson()).join(';'),
    'subTasks': subTasks.join(';'),
    'deleted': deleted,
    'rev': rev,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  static TaskPattern fromJson(String m) =>
      fromMap(jsonDecode(m) as Map<String, dynamic>);

  static TaskPattern fromMap(Map<String, dynamic> map) => TaskPattern(
    id: map['id'],
    title: map['title'],
    completion: Completion.fromJson(map['completion'])!,
    description: map['description'] ?? '',
    startTime: map['startTime'] != null
        ? DateTime.parse(map['startTime']).toLocal()
        : null,
    duration: map['duration'] != null
        ? Duration(milliseconds: map['duration'])
        : null,
    rrule: map['rrule'] != null
        ? RecurrenceRule.fromString(map['rrule'])
        : null,
    tags: map['tags'] != null ? (map['tags'] as String).split(';') : [],
    priority: map['priority'],
    reminders: map['reminders'] != null && map['reminders'].isNotEmpty
        ? (map['reminders'] as String)
              .split(';')
              .map((e) => NotiReminder.fromJson(e)!)
              .toList()
        : [],
    subTasks: map['subTasks'] != null && map['subTasks'].isNotEmpty
        ? (map['subTasks'] as String).split(';')
        : [],
    deleted: map['deleted'] ?? false,
    rev: map['rev'] ?? 0,
    createdAt: DateTime.parse(map['createdAt']).toLocal(),
    updatedAt: DateTime.parse(map['updatedAt']).toLocal(),
  );
}
