part of 'task_bloc.dart';

@immutable
sealed class TaskState extends Equatable {
  final TaskEvent? event;
  const TaskState({this.event});
  @override
  List<Object?> get props => [event];
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

final class TaskLoading extends TaskState {
  const TaskLoading({super.event});
}

final class TaskLoaded extends TaskState {
  final List<Task> taskList;
  final TaskFilter filter;

  const TaskLoaded({
    required this.taskList,
    this.filter = TaskFilter.all,
    super.event,
  });

  TaskLoaded copyWith({
    List<Task>? taskList,
    TaskFilter? filter,
    TaskEvent? event,
  }) {
    return TaskLoaded(
      taskList: taskList ?? this.taskList,
      filter: filter ?? this.filter,
      event: event ?? this.event,
    );
  }

  List<Task> get filteredTasks {
    switch (filter) {
      case TaskFilter.active:
        return taskList.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return taskList.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
      default:
        return taskList;
    }
  }

  @override
  List<Object?> get props => [taskList, filter, event];
}

final class TaskEmpty extends TaskState{
  const TaskEmpty({super.event});
}

final class TaskLoadFailure extends TaskState {
  final String errorMessage;
  const TaskLoadFailure(this.errorMessage, {super.event});

  @override
  List<Object?> get props => [errorMessage, event];
}