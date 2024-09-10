import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description= "";
  DateTime dueDate = DateTime.now();
  TimeOfDay dueTime = TimeOfDay.now();
  Priority priority = Priority.low;
  bool repeat = false;

  Future<void> _pickDueDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if(!mounted) return;
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: dueTime);
    if((pickedTime != null && pickedTime != dueTime) && (pickedDate != null && pickedDate != dueDate)) {
      setState(() {
        dueDate = pickedDate;
        dueTime = pickedTime;
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newTask = Task(
        title: title,
        description: description,
        dueDateTime: Task.toStringDateTime(dueDate, dueTime),
        repeat: repeat,
        priority: priority,
        createdAt: DateFormat('d MMM, y').format(DateTime.now())
      );
      ref.read(tasksNotifierProvider.notifier).addTask(newTask);
      Navigator.of(context).pop({'added': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                style: Theme.of(context).textTheme.headlineMedium,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add a Title"
                ),
                validator: (value) {
                  if(value == null || value.isEmpty || value.trim() == '' ) return 'Please enter a title';
                  return null;
                },
                onSaved: (newValue) => setState(() {
                  title = newValue!;
                }),
              ), 

              const SizedBox(height: 20,),

              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
                  ),
                  onPressed: _pickDueDateTime, 
                  label: Text(DateFormat('d MMM, y, HH:mm').format(DateTime(dueDate.year, dueDate.month, dueDate.day, dueTime.hour, dueTime.minute))),
                  icon: const Icon(Icons.access_time),
                ),
              ),

              const SizedBox(width: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<Priority>(
                      value: Priority.high,
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
                      onChanged: (value) {
                        priority = value!;
                      }
                    ),
                  ),
                  Expanded(
                    child: SwitchListTile(
                      title: const Text("Repeat"),
                      value: repeat, 
                      onChanged: (value) {
                        setState(() {
                          repeat = value;
                        });
                      }
                    ),
                  )
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add a Description"
                    ),
                    maxLines: null,
                    onChanged: (value) => setState(() {
                      description = value;
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 80,)

            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitTask,
        label: Text(
          "Add",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}