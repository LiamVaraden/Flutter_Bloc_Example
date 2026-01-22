import 'package:bloc_first_learning_example/features/task/presentation/bloc/task_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/domain/task.dart';
import '../../data/repositories/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';


final class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(const TaskInitial()) {
    on<AddTask>(_onAddTask);
    on<LoadTasks>(_onLoadTasks);
    on<FilterTasks>(_onFilterTasks);
    on<UpdateTask>(_onUpdateTask);
  }

  void _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading(event: event));
    try {
      final newTask = Task(
        id: DateTime.now().toString(),
        title: event.taskDescription,
      );
      await repository.addTask(newTask);
      final tasks = await repository.getTasks();
      emit(TaskLoaded(taskList: tasks, event: event));
    } catch (e) {
      emit(TaskLoadFailure('Error adding task', event: event));
    }
  }

  void _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading(event: event));
    try {
      final tasks = await repository.getTasks();
      emit(TaskLoaded(taskList: tasks, filter: event.filter, event: event));
    } catch (e) {
      emit(TaskLoadFailure('Error loading tasks', event: event));
    }
  }

  void _onFilterTasks(FilterTasks event, Emitter<TaskState> emit) {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(currentState.copyWith(filter: event.filter, event: event));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    final currentState = state;
    if (currentState is TaskLoaded) {
      emit(TaskLoading(event: event));
      try {
        await repository.updateTask(event.task);
        final tasks = await repository.getTasks();
        emit(TaskLoaded(
          taskList: tasks,
          filter: currentState.filter,
          event: event,
        ));
      } catch (e) {
        emit(TaskLoadFailure('Error updating task', event: event));
      }
    }
  }
}
