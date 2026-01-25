import 'package:drift/drift.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/noti_reminder.dart';
import 'package:rrule/rrule.dart';
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
      startTime = entry.startTime,
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
      createdAt = entry.createdAt,
      updatedAt = entry.updatedAt;

  TaskPatternsCompanion toCompanion() {
    return TaskPatternsCompanion(
      id: Value(id),
      title: Value(title),
      completion: Value(completion.toJson()),
      description: Value(description.isNotEmpty ? description : null),
      startTime: Value(startTime),
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
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
