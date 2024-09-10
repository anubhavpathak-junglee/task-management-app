import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  const TaskDetailsScreen({ required this.task, super.key });

  final Task task;

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  late TextEditingController descriptionController;
  late TextEditingController titleController;

  bool _showSaveButton = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    titleController.addListener(() {
      if(titleController.text != widget.task.title){
        setState(() {
          _showSaveButton = true;
        });
      } else {
        setState(() {
          _showSaveButton = false;
        });
      }
    });
    descriptionController.addListener(() {
      if (descriptionController.text != widget.task.description) {
        setState(() {
          _showSaveButton = true;
        });
      } else {
        setState(() {
          _showSaveButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Task task = widget.task;

    Future<void> changeDueDateTime() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: task.dateTime(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
      if(!mounted) return;
      TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: task.timeOfDay());
      if((pickedTime != null) && (pickedDate != null)) {
        setState(() {
          task.dueDateTime = Task.toStringDateTime(pickedDate, pickedTime);
          _showSaveButton = true;
        });
      }
    }

    void changePriority (Priority? newValue) {
      setState(() {
        task.priority = newValue!;
        _showSaveButton = true;
      });
    }
    
    void toggleRepeat (value) {
      setState(() {
        task.repeat = value;
        _showSaveButton = true;
      });
    }

    void toggleIsCompleted () {
      setState(() {
        task.isCompleted = !task.isCompleted;
        _showSaveButton = true;
      });
    }

    void saveChanges() {
      setState(() {
        task.title = titleController.text;
        task.description = descriptionController.text;
        _showSaveButton = false;
      });
      ref.read(tasksNotifierProvider.notifier).updateTask(task);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task Updated !")
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(task.createdAt),
        actions: [
          if(_showSaveButton)
          TextButton.icon(
            onPressed: saveChanges, 
            label: const Text("Save"),
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: titleController, 
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                border: InputBorder.none
              ),
            ), 

            const SizedBox(height: 20,),

            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                ),
                onPressed: changeDueDateTime, 
                label: Text(task.dueDateTime),
                icon: const Icon(Icons.access_time),
              ),
            ),

            const SizedBox(width: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<Priority>(
                    value: task.priority,
                    decoration: const InputDecoration(
                      prefixText: "Priority ",
                      border: InputBorder.none,
                    ),
                    items: Priority.values.map((Priority priority) {
                      return DropdownMenuItem<Priority>(
                        value: priority,
                        child: Text(priority.toString().split('.').last[0].toUpperCase() + priority.toString().split('.').last.substring(1)),
                      );
                    }).toList(),
                    onChanged: changePriority
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text("Repeat"),
                    value: task.repeat, 
                    onChanged: toggleRepeat
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add a description',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80,)
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}