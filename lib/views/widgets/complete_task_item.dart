import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';

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