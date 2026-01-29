import 'package:drift/drift.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/noti_reminder.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/local_db.dart';

class TaskOverride {
  String taskId;
  DateTime rid;

  String? title;
  Completion? completion;

  String? description;

  DateTime? startTime;
  Duration? duration;
  DateTime? get endTime => (startTime != null && duration != null)
      ? startTime!.add(duration!)
      : null;

  List<String>? tags;
  int? priority;
  List<NotiReminder>? reminders;
  List<(String name, bool completed)>? subTasks;

  bool? deleted = false;

  DateTime createdAt;
  DateTime updatedAt;

  TaskOverride({
    required this.taskId,
    required this.rid,
    this.title,
    this.completion,
    this.description,
    this.startTime,
    this.duration,
    this.tags,
    this.priority,
    this.reminders,
    this.subTasks,
    this.deleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  TaskOverride.fromPattern(
    TaskPattern tp,
    this.rid, {
    this.title,
    this.completion,
    this.description,
    this.startTime,
    this.duration,
    this.tags,
    this.priority,
    this.reminders,
    this.subTasks,
    this.deleted = false,
  }) : taskId = tp.id,
       createdAt = tp.createdAt,
       updatedAt = DateTime.now();

  TaskOverride copyWith({
    String? taskId,
    DateTime? rid,
    String? title,
    Completion? completion,
    String? description,
    DateTime? startTime,
    Duration? duration,
    List<String>? tags,
    int? priority,
    List<NotiReminder>? reminders,
    bool? deleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<(String name, bool completed)>? subTasks,
  }) {
    return TaskOverride(
      taskId: taskId ?? this.taskId,
      rid: rid ?? this.rid,
      title: title ?? this.title,
      completion: completion ?? this.completion,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      duration: duration ?? this.duration,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      reminders: reminders ?? this.reminders,
      subTasks: subTasks ?? this.subTasks,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  TaskOverride.fromEntry(TaskOverrideEntry entry)
    : taskId = entry.taskId,
      rid = entry.rid,
      title = entry.title,
      completion = entry.completion != null
          ? Completion.fromJson(entry.completion!)
          : null,
      description = entry.description,
      startTime = entry.startTime,
      duration = entry.duration != null
          ? Duration(milliseconds: entry.duration!)
          : null,
      tags = entry.tags != null && entry.tags!.isNotEmpty
          ? entry.tags!.split(';')
          : null,
      priority = entry.priority,
      reminders = entry.reminders != null && entry.reminders!.isNotEmpty
          ? entry.reminders!
                .split(';')
                .map((e) => NotiReminder.fromJson(e)!)
                .toList()
          : null,
      subTasks = entry.subTasks != null && entry.subTasks!.isNotEmpty
          ? entry.subTasks!.split(';').map((e) {
              final parts = e.split(',');
              return (parts[0], parts[1].toLowerCase() == 'true');
            }).toList()
          : null,
      deleted = entry.deleted,
      createdAt = entry.createdAt,
      updatedAt = entry.updatedAt;

  TaskOverridesCompanion toCompanion() {
    return TaskOverridesCompanion.insert(
      taskId: taskId,
      rid: rid,
      title: Value(title),
      completion: Value(completion?.toJson()),
      description: Value(description),
      startTime: Value(startTime),
      duration: Value(duration?.inMilliseconds),
      tags: Value(tags?.join(';')),
      priority: Value(priority),
      reminders: Value(reminders?.map((e) => e.toJson()).join(';')),
      subTasks: Value(subTasks?.map((e) => '${e.$1},${e.$2}').join(';')),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  TaskOverride add(TaskOverride? override) {
    if (override == null) return this;
    if (override.title != null) title = override.title;
    if (override.completion != null) completion = override.completion;
    if (override.description != null) description = override.description;
    if (override.startTime != null) startTime = override.startTime;
    if (override.duration != null) duration = override.duration;
    if (override.tags != null) tags = override.tags;
    if (override.priority != null) priority = override.priority;
    if (override.reminders != null) reminders = override.reminders;
    if (override.subTasks != null) subTasks = override.subTasks;
    if (override.deleted != null) deleted = override.deleted;
    updatedAt = DateTime.now();
    return this;
  }
}
