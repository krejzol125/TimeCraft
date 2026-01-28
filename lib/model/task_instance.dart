import 'package:drift/drift.dart';
import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/noti_reminder.dart';
import 'package:timecraft/model/task_override.dart';
import 'package:timecraft/model/task_pattern.dart';
import 'package:timecraft/repo/drift/local_db.dart';

class TaskInstance {
  String taskId;
  DateTime? rid;

  String title;
  Completion completion;

  String description;

  DateTime? startTime;
  Duration? duration;
  DateTime? get endTime => (startTime != null && duration != null)
      ? startTime!.add(duration!)
      : null;
  bool isRepeating;

  List<String> tags;
  int priority;
  List<NotiReminder> reminders;
  List<(String name, bool completed)> subTasks;

  TaskInstance({
    required this.taskId,
    required this.title,
    Completion? completion,
    this.description = '',
    this.startTime,
    this.duration,
    this.isRepeating = false,
    this.tags = const [],
    this.priority = 3,
    this.reminders = const [],
    this.subTasks = const [],
  }) : completion = completion ?? BinaryCompletion(false);

  TaskInstance.fromPattern(
    TaskPattern tp,
    DateTime? startTime, {
    TaskOverride? taskOverride,
  }) : taskId = tp.id,
       rid = startTime,
       title = taskOverride?.title ?? tp.title,
       completion = taskOverride?.completion ?? tp.completion,
       description = taskOverride?.description ?? tp.description,
       startTime = taskOverride?.startTime ?? startTime,
       duration = taskOverride?.duration ?? tp.duration,
       isRepeating = tp.rrule != null,
       tags = taskOverride?.tags ?? tp.tags,
       priority = taskOverride?.priority ?? tp.priority,
       reminders = taskOverride?.reminders ?? tp.reminders,
       subTasks =
           taskOverride?.subTasks ??
           tp.subTasks.map((name) => (name, false)).toList();

  TaskInstance copyWith({
    String? taskId,
    String? title,
    Completion? completion,
    String? description,
    DateTime? startTime,
    Duration? duration,
    bool? isRepeating,
    List<String>? tags,
    int? priority,
    List<NotiReminder>? reminders,
    List<(String name, bool completed)>? subTasks,
  }) {
    return TaskInstance(
      taskId: taskId ?? this.taskId,
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
    );
  }

  TaskInstance.fromEntry(TaskInstanceEntry entry)
    : taskId = entry.taskId,
      title = entry.title,
      completion = Completion.fromJson(entry.completion)!,
      description = entry.description ?? '',
      startTime = entry.startTime,
      duration = entry.duration != null
          ? Duration(milliseconds: entry.duration!)
          : null,
      isRepeating = entry.isRepeating,
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
          ? entry.subTasks!.split(';').map((e) {
              final parts = e.split(',');
              return (parts[0], parts[1].toLowerCase() == 'true');
            }).toList()
          : [],
      rid = entry.rid;

  TaskInstancesCompanion toCompanion() {
    return TaskInstancesCompanion.insert(
      taskId: taskId,
      title: title,
      completion: Value(completion.toJson()),
      description: Value(description),
      startTime: Value(startTime),
      duration: Value(duration?.inMilliseconds),
      isRepeating: Value(isRepeating),
      tags: Value(tags.join(';')),
      priority: Value(priority),
      reminders: Value(reminders.map((e) => e.toJson()).join(';')),
      subTasks: Value(subTasks.map((e) => "${e.$1},${e.$2}").join(';')),
      deleted: Value(false),
      rid: Value(rid),
    );
  }
}
