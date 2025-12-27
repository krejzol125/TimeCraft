import 'dart:math';

abstract class Completion {
  Completion({required this.id, this.completionTime});

  int id;
  DateTime? completionTime;

  static Completion? fromJson(String json) {
    List<String> values = json.trim().split(" ");
    if (values.isEmpty) return null;
    switch (int.parse(values[0])) {
      case 0:
        return BinaryCompletion(
          bool.parse(values[1]),
          completionTime: values.length == 3 ? DateTime.parse(values[2]) : null,
        );
      case 1:
        return QuantityCompletion(
          int.parse(values[1]),
          int.parse(values[2]),
          completionTime: values.length == 4 ? DateTime.parse(values[3]) : null,
        );
    }
    return null;
  }

  void mark(int completed);
  bool get isCompleted;

  String toJson();
}

class BinaryCompletion extends Completion {
  BinaryCompletion(this.comp, {super.completionTime}) : super(id: 0);

  bool comp;

  @override
  bool get isCompleted => comp;

  @override
  void mark(int completed) {
    comp = completed != 0;
    if (comp) completionTime = DateTime.now();
  }

  @override
  String toJson() {
    return "0 $comp ${completionTime != null ? completionTime!.toIso8601String() : ""}";
  }
}

class QuantityCompletion extends Completion {
  QuantityCompletion(this.cap, this.comp, {super.completionTime})
    : super(id: 1);

  int cap;
  int comp;

  @override
  bool get isCompleted => cap == comp;

  @override
  void mark(int completed) {
    comp = max(min(cap, completed), 0);
    if (cap == comp) completionTime = DateTime.now();
  }

  @override
  String toJson() {
    return "1 $cap $comp ${completionTime != null ? completionTime!.toIso8601String() : ""}";
  }
}
