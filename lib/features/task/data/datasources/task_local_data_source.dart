import 'dart:convert';
import 'package:bloc_first_learning_example/features/task/data/model/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> clearTasks();
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _tasksKey = 'CACHED_TASKS';

  TaskLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TaskModel>> getTasks() async {
    final jsonString = sharedPreferences.getString(_tasksKey);
    if (jsonString != null) {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final jsonList = tasks.map((task) => task.toJson()).toList();
    await sharedPreferences.setString(_tasksKey, jsonEncode(jsonList));
  }

  @override
  Future<void> clearTasks() async {
    await sharedPreferences.remove(_tasksKey);
  }
}