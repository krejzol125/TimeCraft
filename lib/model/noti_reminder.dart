abstract class NotiReminder {
  NotiReminder({required this.id});
  int id;

  //todo Add ways to remind
  DateTime whenToRemind(DateTime taskStartTime);

  static NotiReminder? fromJson(String? json) {
    if (json == null) return null;

    List<String> values = json.trim().split(" ");
    try {
      if (values.length <= 1) return null;
      switch (int.parse(values[0])) {
        case 0:
          return AbsoluteNotiReminder(DateTime.parse(values[1]));
        case 1:
          return RelativeNotiReminder(Duration(seconds: int.parse(values[1])));
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  String toJson();
}

class AbsoluteNotiReminder extends NotiReminder {
  AbsoluteNotiReminder(this.reminder) : super(id: 0);

  DateTime reminder;

  @override
  DateTime whenToRemind(DateTime taskStartTime) {
    return taskStartTime.copyWith(
      hour: reminder.hour,
      minute: reminder.minute,
      second: reminder.second,
    );
  }

  @override
  String toJson() {
    return "0 ${reminder.toIso8601String()}";
  }
}

class RelativeNotiReminder extends NotiReminder {
  RelativeNotiReminder(this.reminder) : super(id: 1);

  Duration reminder;

  @override
  DateTime whenToRemind(DateTime taskStartTime) {
    return taskStartTime.subtract(reminder);
  }

  @override
  String toJson() {
    return "1 ${reminder.inSeconds}";
  }
}
