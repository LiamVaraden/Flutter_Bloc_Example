part of 'task_bloc.dart';



@immutable
sealed class TaskEvent {
  final int taskId;
  const TaskEvent(this.taskId);
}

final class LoadTasks extends TaskEvent {
  final TaskFilter filter;
  const LoadTasks(super.taskId, {required this.filter});
}

final class AddTask extends TaskEvent {
  final String taskDescription;
  const AddTask(super.taskId, {required this.taskDescription});
}

final class FilterTasks extends TaskEvent {
  final TaskFilter filter;
  const FilterTasks(super.taskId, {required this.filter});
}

final class UpdateTask extends TaskEvent{
  final Task task;
  const UpdateTask(super.taskId, {required this.task});
}

