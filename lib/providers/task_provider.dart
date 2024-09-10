import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/utils/db_helper.dart';

class TasksNotifier extends StateNotifier<List<Task>> {

  final dbHelper = DBHelper();

  List<Task> tasks = [];
  String sortBy = 'priority';
  String search = '';
  DateTime? selectedDate;

  TasksNotifier() : super([]) {
    _loadSortPreferences();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await dbHelper.getTasks(search, selectedDate);
    _sortTasks();
    state = tasks;
  }

  void addTask(Task task) async {
    await dbHelper.insertTask(task);
    tasks.add(task);
    _sortTasks();
    state = [...tasks];
  }

  void removeTask(Task task) async {
    await dbHelper.deleteTask(task.id!);
    tasks.remove(task);
    state = [...tasks];
  }

  void updateTask(Task task) async {
    await dbHelper.updateTask(task);
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      _sortTasks();
      state = [...tasks];
    }
  }

  void _sortTasks() {
    if (sortBy == 'priority') {
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else if (sortBy == 'dueDate') {
      tasks.sort((a, b) => a.dateTime().compareTo(b.dateTime()));
    } else if (sortBy == 'createdAt') {
      tasks.sort((a, b) => a.createdDateTime.compareTo(b.createdDateTime));
    }
  }

  void toggleSortBy(String key) async {
    sortBy = key;
    await _saveSortPreferences();
    _sortTasks();
    state = [...tasks];
  }

  Future<void> _loadSortPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    sortBy = prefs.getString('sort') ?? 'priority';
    state = [...tasks];
  }

  Future<void> _saveSortPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sort', sortBy);
  }

  void setSearch(String query) {
    search = query;
    loadTasks();
  }

  void setSelectedDate(DateTime? date) {
    selectedDate = date;
    loadTasks();
  }
}

final tasksNotifierProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) => TasksNotifier());
