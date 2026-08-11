import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Task> _tasks = [];
  bool _loading = false;
  bool _onboardingComplete = false;
  int _dailyTasksCount = 0;
  DateTime? _lastTaskAt;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get loading => _loading;
  bool get onboardingComplete => _onboardingComplete;
  int get dailyTasksCount => _dailyTasksCount;

  Future<void> init() async {
    _loading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    _onboardingComplete = prefs.getBool('onboarding_done') ?? false;
    _dailyTasksCount = prefs.getInt('daily_tasks_count') ?? 0;
    String? lastTaskStr = prefs.getString('last_task_at');
    if (lastTaskStr != null) {
      _lastTaskAt = DateTime.parse(lastTaskStr);
      
      // Reset daily count if it's a new day
      if (_lastTaskAt!.day != DateTime.now().day) {
        _dailyTasksCount = 0;
        await prefs.setInt('daily_tasks_count', 0);
      }
    }
    
    await refreshTasks();
    
    _loading = false;
    notifyListeners();
  }

  Future<void> refreshTasks() async {
    _tasks = await _db.getTasks();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    _onboardingComplete = true;
    notifyListeners();
  }

  Future<bool> createTask(String title, {String? description, String? transcription}) async {
    if (_dailyTasksCount >= 5) return false;

    final task = Task(
      title: title,
      description: description,
      transcription: transcription,
      createdAt: DateTime.now(),
    );

    await _db.insertTask(task);
    
    _dailyTasksCount++;
    _lastTaskAt = DateTime.now();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_tasks_count', _dailyTasksCount);
    await prefs.setString('last_task_at', _lastTaskAt!.toIso8601String());
    
    await refreshTasks();
    return true;
  }

  Future<void> toggleTask(Task task) async {
    final updated = task.copyWith(status: task.isCompleted ? 'pending' : 'completed');
    await _db.updateTask(updated);
    await refreshTasks();
  }

  Future<void> deleteTask(int id) async {
    await _db.deleteTask(id);
    await refreshTasks();
  }
}
