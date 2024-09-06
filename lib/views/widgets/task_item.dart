import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/views/screens/task_details_screen.dart';

class TaskItem extends ConsumerStatefulWidget {
  const TaskItem({required this.task, super.key });

  final Task task;

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  @override
  Widget build(BuildContext context) {

    Task task = widget.task;
    Icon? priorityIcon;

    void toggleCheck() {
      task.isCompleted = !task.isCompleted;
      ref.read(tasksNotifierProvider.notifier).updateTask(task);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: task.isCompleted ? const Text('Task marked as completed') : const Text('Task marked as incomplete'),
        ),
      );
    }

    switch (task.priority) {
      case Priority.high:
        priorityIcon = const Icon(Icons.priority_high, color: Colors.red);
        break;
      case Priority.medium:
        priorityIcon = const Icon(Icons.priority_high, color: Colors.orange);
        break;
      case Priority.low:
        priorityIcon = null;
        break;
    }

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailsScreen(task: task))),
      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              if (priorityIcon != null) priorityIcon,
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Due on ${DateFormat('MMM d, yyyy').format(task.dueDate)}', style: Theme.of(context).textTheme.labelSmall!),
                  const SizedBox(height: 10),
                  Text(task.title.length > 30 ? '${task.title.substring(0, 30)}...' : task.title, style: Theme.of(context).textTheme.titleMedium!),
                  Text(task.description.length > 30 ? '${task.description.substring(0, 30)}...' : task.description, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const Spacer(),
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => toggleCheck(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CompleteTaskItem extends ConsumerStatefulWidget {
  const CompleteTaskItem({required this.task, super.key });

  final Task task;

  @override
  ConsumerState<CompleteTaskItem> createState() => _CompleteTaskItemState();
}

class _CompleteTaskItemState extends ConsumerState<CompleteTaskItem> {
  @override
  Widget build(BuildContext context) {

    Task task = widget.task;

    void toggleCheck() {
      task.isCompleted = !task.isCompleted;
      ref.read(tasksNotifierProvider.notifier).updateTask(task);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: task.isCompleted ? const Text('Task marked as completed') : const Text('Task marked as incomplete'),
        ),
      );
    }

    return ListTile(
      title: Text(task.title.length > 30 ? '${task.title.substring(0, 30)}...' : task.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: (_) => toggleCheck(),
      ),
    );
  }
}