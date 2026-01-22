import 'package:bloc_first_learning_example/features/task/presentation/bloc/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/domain/task.dart';
import '../bloc/task_enum.dart';


class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Task List'))
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
    child:Column(
        children: [
        _buildAddTask(),
        const SizedBox(height: 20),
        _buildFilter(),
          const SizedBox(height: 20),
        Expanded(child: _buildTaskList()),
      ],
    ),
      ),
    );
  }

  Widget _buildAddTask(){
    return Row(
    children: [
      Expanded(
        child: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            labelText: 'New Task',
          ),
          onSubmitted: (value) => _addTask(),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: _addTask
      ),
    ],
    );
  }

  void _addTask(){
    if (_taskController.text.isNotEmpty) {
      context.read<TaskBloc>().add(
        AddTask(0, taskDescription: _taskController.text),
      );
      _taskController.clear();
    }
  }

  Widget _buildFilter(){
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        final currentFilter = state is TaskLoaded ? state.filter : TaskFilter.all;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFilterButton('All', TaskFilter.all, currentFilter),
            const SizedBox(width: 8),
            _buildFilterButton('Active', TaskFilter.active, currentFilter),
            const SizedBox(width: 8),
            _buildFilterButton('Completed', TaskFilter.completed, currentFilter),
          ],
        );
      },
    );
  }
  Widget _buildFilterButton(String label, TaskFilter filter, TaskFilter currentFilter) {
    final isSelected = filter == currentFilter;

    return OutlinedButton(
      onPressed: () {
        context.read<TaskBloc>().add(FilterTasks(0, filter: filter));
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : null,
        foregroundColor: isSelected ? Colors.white : null,
      ),
      child: Text(label),
    );
  }

  Widget _buildTaskList() {
    return BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
      if (state is TaskLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is TaskLoadFailure) {
        return Center(child: Text(state.errorMessage));
      }

      if (state is TaskLoaded) {
        final tasks = state.filteredTasks;

        if (tasks.isEmpty) {
          return const Center(child: Text('No tasks yet!'));
        }

        return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
              leading: Checkbox(
              value: task.isCompleted,
              onChanged: (value) {
                final updatedTask = Task(
                  id: task.id,
                  title: task.title,
                  isCompleted: value ?? false,
                );
                context.read<TaskBloc>().add(
                  UpdateTask(0, task: updatedTask),
                );
              },
              ),
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          );
            },
        );
      }

      return const Center(child: Text('No tasks yet!'));
        },
    );
  }
}

/// StatefulWidget
/// Has TextEditingController for managing text
/// Uses local variable or onChanged callback
/// Controller needs dispose() cleanup
/// Can store mutable state (_taskController)
/// Methods can access instance fields
///
/// StatelessWidget
/// No cleanup needed
/// All state managed by BLoC
/// Methods need BuildContext passed as parameter
///
/// Trade-offs
/// StatelessWidget Benefits:
/// Simpler - no lifecycle methods
/// More aligned with BLoC pattern (all state in BLoC)
/// Less boilerplate
/// StatelessWidget Drawbacks:
/// TextField won't auto-clear after adding task (no controller to call .clear())
/// Can't easily focus/unfocus TextField programmatically
/// Local variable approach for text is less reliable
/// Better Alternative: Use StatefulWidget
/// For forms with TextField, StatefulWidget is recommended because:
/// You can clear the field after submission
/// You can validate input before submission
/// You can manage focus states
/// Controllers provide better text management
/// I think stateful is the best approach for my use case here.


/// If I were to use a stateless widget, the code would look like this:
// import 'package:bloc_first_learning_example/features/task/presentation/bloc/task_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../data/domain/task.dart';
// import '../bloc/task_enum.dart';
//
// class TaskListScreen extends StatelessWidget {
//   const TaskListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Task List')),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _buildAddTask(context),
//             const SizedBox(height: 20),
//             _buildFilter(),
//             const SizedBox(height: 20),
//             Expanded(child: _buildTaskList()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAddTask(BuildContext context) {
//     String taskText = '';
//
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: const InputDecoration(
//               labelText: 'New Task',
//             ),
//             onChanged: (value) => taskText = value,
//             onSubmitted: (value) => _addTask(context, value),
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.add),
//           onPressed: () => _addTask(context, taskText),
//         ),
//       ],
//     );
//   }
//
//   void _addTask(BuildContext context, String taskText) {
//     if (taskText.isNotEmpty) {
//       context.read<TaskBloc>().add(
//         AddTask(0, taskDescription: taskText),
//       );
//     }
//   }
//
//   Widget _buildFilter() {
//     return BlocBuilder<TaskBloc, TaskState>(
//       builder: (context, state) {
//         final currentFilter = state is TaskLoaded ? state.filter : TaskFilter.all;
//
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildFilterButton('All', TaskFilter.all, currentFilter),
//             const SizedBox(width: 8),
//             _buildFilterButton('Active', TaskFilter.active, currentFilter),
//             const SizedBox(width: 8),
//             _buildFilterButton('Completed', TaskFilter.completed, currentFilter),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildFilterButton(String label, TaskFilter filter, TaskFilter currentFilter) {
//     return Builder(
//       builder: (context) {
//         final isSelected = filter == currentFilter;
//
//         return OutlinedButton(
//           onPressed: () {
//             context.read<TaskBloc>().add(FilterTasks(0, filter: filter));
//           },
//           style: OutlinedButton.styleFrom(
//             backgroundColor: isSelected ? Colors.blue : null,
//             foregroundColor: isSelected ? Colors.white : null,
//           ),
//           child: Text(label),
//         );
//       },
//     );
//   }
//
//   Widget _buildTaskList() {
//     return BlocBuilder<TaskBloc, TaskState>(
//       builder: (context, state) {
//         if (state is TaskLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (state is TaskLoadFailure) {
//           return Center(child: Text(state.errorMessage));
//         }
//
//         if (state is TaskLoaded) {
//           final tasks = state.filteredTasks;
//
//           if (tasks.isEmpty) {
//             return const Center(child: Text('No tasks yet!'));
//           }
//
//           return ListView.builder(
//             itemCount: tasks.length,
//             itemBuilder: (context, index) {
//               final task = tasks[index];
//               return ListTile(
//                 leading: Checkbox(
//                   value: task.isCompleted,
//                   onChanged: (value) {
//                     final updatedTask = Task(
//                       id: task.id,
//                       title: task.title,
//                       isCompleted: value ?? false,
//                     );
//                     context.read<TaskBloc>().add(
//                       UpdateTask(0, task: updatedTask),
//                     );
//                   },
//                 ),
//                 title: Text(
//                   task.title,
//                   style: TextStyle(
//                     decoration: task.isCompleted
//                         ? TextDecoration.lineThrough
//                         : TextDecoration.none,
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//
//         return const Center(child: Text('No tasks yet!'));
//       },
//     );
//   }
// }