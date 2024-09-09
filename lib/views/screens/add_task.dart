import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();
  Priority _priority = Priority.medium;

  Future<void> _pickDueDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _dueDate) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final DateTime now = DateTime.now();
      final newTask = Task(
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
        createdAt: DateTime(now.year, now.month, now.day),
      );

      ref.read(tasksNotifierProvider.notifier).addTask(newTask);

      Navigator.of(context).pop({'added': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title'
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Description'
                ), onSaved: (value) {
                  _description = value!;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Priority>(
                      value: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: Priority.values.map((Priority priority) {
                        return DropdownMenuItem<Priority>(
                          value: priority,
                          child: Text(priority.toString().split('.').last[0].toUpperCase() + priority.toString().split('.').last.substring(1)),
                        );
                      }).toList(),
                      onChanged: (Priority? newValue) {
                        setState(() {
                          _priority = newValue!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text("Due Date"),
                      subtitle: Text(
                          "${_dueDate.year}-${_dueDate.month}-${_dueDate.day}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _pickDueDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Clear', textAlign: TextAlign.right,),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitTask,
                      child: const Text('Add Task'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}