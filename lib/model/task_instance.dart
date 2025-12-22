import 'package:timecraft/model/completion.dart';
import 'package:timecraft/model/noti_reminder.dart';
//import 'package:rrule/rrule.dart';

class TaskInstance {
  int id;
  String title;
  Completion completion;

  String description;

  DateTime? startTime;
  DateTime? endTime;
  Duration? get duration => (startTime != null && endTime != null)
      ? endTime!.difference(startTime!)
      : null;
  //RecurrenceRule? rrule; TODO

  List<String> tags;
  int priority; // 1-5
  List<NotiReminder> reminders;
  List<(String name, bool completed)> subTasks;

  TaskInstance({
    required this.id,
    required this.title,
    Completion? completion,
    this.description = '',
    this.startTime,
    this.endTime,
    this.tags = const [],
    this.priority = 3,
    this.reminders = const [],
    this.subTasks = const [],
  }) : completion = completion ?? BinaryCompletion(false);

  TaskInstance copyWith({
    int? id,
    String? title,
    Completion? completion,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? tags,
    int? priority,
    List<NotiReminder>? reminders,
    List<(String name, bool completed)>? subTasks,
  }) {
    return TaskInstance(
      id: id ?? this.id,
      title: title ?? this.title,
      completion: completion ?? this.completion,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      reminders: reminders ?? this.reminders,
      subTasks: subTasks ?? this.subTasks,
    );
  }
}
