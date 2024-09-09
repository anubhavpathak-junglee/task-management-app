enum Priority { low, medium, high }

class Task {
  int? id;
  String title;
  String description;
  DateTime dueDate;
  Priority priority;
  bool isCompleted;
  DateTime createdAt = DateTime.now();

  Task({this.id, required this.title, required this.description, required this.dueDate, required this.priority, this.isCompleted = false, required DateTime createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.index,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String().split('T').first,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      priority: Priority.values[map['priority']],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
