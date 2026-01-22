import 'package:bloc_first_learning_example/features/task/data/datasources/task_local_data_source.dart';
import 'package:bloc_first_learning_example/features/task/data/domain/task.dart';
import 'package:bloc_first_learning_example/features/task/data/model/task_model.dart';
import 'package:bloc_first_learning_example/features/task/data/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;

  TaskRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Task>> getTasks() async {
    final taskModels = await localDataSource.getTasks();
    return taskModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    final tasks = await localDataSource.getTasks();
    tasks.add(TaskModel.fromEntity(task));
    await localDataSource.saveTasks(tasks);
  }

  @override
  Future<void> updateTask(Task task) async {
    final tasks = await localDataSource.getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = TaskModel.fromEntity(task);
      await localDataSource.saveTasks(tasks);
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await localDataSource.getTasks();
    tasks.removeWhere((t) => t.id == id);
    await localDataSource.saveTasks(tasks);
  }
}