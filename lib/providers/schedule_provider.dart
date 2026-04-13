import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class ScheduleProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  final Set<String> _completedIds = {};
  final Uuid _uuid = const Uuid();

  List<TaskModel> get task => _tasks;
  Set<String> get completedIds => _completedIds;

  bool isCompleted(String id) => _completedIds.contains(id);

  void AddTask({
    required String title, required String category, required DateTime date,
    required TimeOfDay startTime, required TimeOfDay endTime,
    required int urgency, required int importance,
    required double estimatedEffortHours, required String energyLevel,
  }) {
    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title,
      category: category,
      date: date,
      startTime: startTime,
      endTime: endTime,
      urgency: urgency,
      importance: importance,
      estimatedEffortHours: estimatedEffortHours,
      energyLevel: energyLevel,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _completedIds.remove(id);
    notifyListeners();
  }

  void toggleComplete(String id) {
    if (_completedIds.contains(id)) {
      _completedIds.remove(id);
    } else {
      _completedIds.add(id);
    }
    notifyListeners();
  }

  void clearAll() {
    _tasks.clear();
    _completedIds.clear();
    notifyListeners();
  }

  // Returns count of overlapping task pairs
  int get conflictCount {
    int count = 0;
    for (int i = 0; i < _tasks.length; i++) {
      for (int j = i + 1; j < _tasks.length; j++) {
        final a = _tasks[i];
        final b = _tasks[j];
        final aStart = a.startTime.hour * 60 + a.startTime.minute;
        final aEnd = a.endTime.hour * 60 + a.endTime.minute;
        final bStart = b.startTime.hour * 60 + b.startTime.minute;
        final bEnd = b.endTime.hour * 60 + b.endTime.minute;
        if (aStart < bEnd && aEnd > bStart) count++;
      }
    }
    return count;
  }

  // Total scheduled minutes
  int get scheduledMinutes {
    int total = 0;
    for (final t in _tasks) {
      final start = t.startTime.hour * 60 + t.startTime.minute;
      final end = t.endTime.hour * 60 + t.endTime.minute;
      if (end > start) total += end - start;
    }
    return total;
  }

  int get completedCount => _completedIds.length;
}