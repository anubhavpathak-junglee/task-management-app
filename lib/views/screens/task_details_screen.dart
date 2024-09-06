import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  const TaskDetailsScreen({ required this.task, super.key });

  final Task task;

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {

  @override
  Widget build(BuildContext context) {

    Task task = widget.task;

    void toggleIsCompleted() {
      task.isCompleted = !task.isCompleted;
      ref.read(tasksNotifierProvider.notifier).updateTask(task);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: task.isCompleted ? const Text('Task marked as completed') : const Text('Task marked as incomplete'),
        ),
      );
    }

    Future<void> changeDueDate() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: task.dueDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if (pickedDate != null && pickedDate != task.dueDate) {
        ref.read(tasksNotifierProvider.notifier).updateTask(task);
        setState(() {
          task.dueDate = pickedDate;
        });
      }
    }

    void changePriority (Priority? newValue) {
      ref.read(tasksNotifierProvider.notifier).updateTask(task);
      setState(() {
        task.priority = newValue!;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task Updated !")
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('d MMM, yyyy').format(task.createdAt))
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0)
                  ),
                  onPressed: changeDueDate, 
                  label: Text(DateFormat('d MMM, yyyy').format(task.dueDate)),
                  icon: const Icon(Icons.access_time),
                ),
                const Spacer(),
                Expanded(
                  child: DropdownButtonFormField<Priority>(
                    value: task.priority,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    items: Priority.values.map((Priority priority) {
                      return DropdownMenuItem<Priority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last[0].toUpperCase() + priority.toString().split('.').last.substring(1)),
                      );
                    }).toList(),
                    onChanged: changePriority,
                  ),
                ), 
              ],
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(Icons.description, color: Theme.of(context).textTheme.titleLarge!.color,),
                  ),
                  TextSpan(
                    text: 'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              initialValue: task.description,
              maxLines: 20,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add a description',
              ),
              onChanged: (value) {
                setState(() {
                  task.description = value;
                });
              },
              // Need something to update the task description
              
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: toggleIsCompleted,
        label: Text(
          task.isCompleted ? 'Mark as Incomplete' : 'Mark as Completed', 
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}