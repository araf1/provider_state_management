import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => totalTasks - completedTasks;

  void addTask({required String title, required String description}) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;

    _tasks.insert(
      0,
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: trimmedTitle,
        description: description.trim(),
      ),
    );
    notifyListeners();
  }

  void toggleTask(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    _tasks[taskIndex] = task.copyWith(isCompleted: !task.isCompleted);
    notifyListeners();
  }

  void deleteTask(String taskId) {
    final taskCountBeforeDelete = _tasks.length;
    _tasks.removeWhere((task) => task.id == taskId);
    if (_tasks.length != taskCountBeforeDelete) notifyListeners();
  }
}
