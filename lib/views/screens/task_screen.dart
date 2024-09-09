import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager/models/task.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/providers/theme_provider.dart';

import 'package:task_manager/views/screens/add_task.dart';
import 'package:task_manager/views/widgets/complete_task_item.dart';
import 'package:task_manager/views/widgets/search.dart';
import 'package:task_manager/views/widgets/sort_options.dart';
import 'package:task_manager/views/widgets/task_item.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({ super.key });

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {

  DateTime? _selectedDate;

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const SortOptions();
      },
    );
  }

  void _showSearch() {
    showModalBottomSheet(
      context: context, 
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => const Search(),
    );
  }

  void _navigateToAddTask() async {
    var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddTaskScreen(),),);
    if (!mounted) return;
    if (result != null && (result as Map)['added'] == true) {
      ref.read(tasksNotifierProvider.notifier).loadTasks();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task added successfully!'),
        )
      );
    }
  }

  void _removeTask(Task task) {
    ref.read(tasksNotifierProvider.notifier).removeTask(task);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task removed successfully!'),
        action: SnackBarAction(label: 'Undo', onPressed: () {
          ref.read(tasksNotifierProvider.notifier).addTask(task);
        }),
      ),
    );
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      ref.read(tasksNotifierProvider.notifier).setSelectedDate(pickedDate);
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;
    final tasks = ref.watch(tasksNotifierProvider);
    final search = ref.watch(tasksNotifierProvider.notifier).search;
    final completedTasks = tasks.where((task) => task.isCompleted).toList();
    final incompleteTasks = tasks.where((task) => !task.isCompleted).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            onPressed: _showSearch,
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {themeNotifier.toggleTheme();},
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.sunny),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              if (search.isNotEmpty)
              ListTile(
                title: Text("Search result for '${ search.length > 10 ? '${search.substring(0, 10)}...' : search }'", 
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).textTheme.titleSmall!.color,
                  )
                ),
                trailing: IconButton(
                  onPressed: () {
                    ref.read(tasksNotifierProvider.notifier).setSearch('');
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),

              if(search.isEmpty && _selectedDate != null)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedDate = null;
                    });
                    ref.read(tasksNotifierProvider.notifier).setSelectedDate(_selectedDate);
                  }, 
                  label: const Text("Reset"),
                  icon: const Icon(Icons.restore),
                ),
              ),

              if(search.isNotEmpty && incompleteTasks.isEmpty && completedTasks.isEmpty)
              Column(
                children: [
                  Image.asset('assets/not_found.png'),
                  const SizedBox(height: 16),
                  Text("Uh oh... found nothing", style: Theme.of(context).textTheme.titleLarge!,),
                  const SizedBox(height: 8),
                  Text("Try searching for something else", style: Theme.of(context).textTheme.titleSmall!,),
                ],
              ),

              if((search.isNotEmpty && incompleteTasks.isNotEmpty) || search.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: incompleteTasks.isEmpty && _selectedDate == null ? 
                Column(
                  children: [
                    Image.asset('assets/no_tasks.png'),
                    const SizedBox(height: 16),
                    Text("All tasks completed !", style: Theme.of(context).textTheme.titleLarge!,),
                    const SizedBox(height: 8),
                    Text("Nice Work :)", style: Theme.of(context).textTheme.titleSmall!,),
                  ],
                )
                :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Incomplete Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: _pickDate,
                              label: _selectedDate == null ? const Text("All") as Widget : Text(DateFormat('d MMM').format(_selectedDate!)),
                              icon: const Icon(Icons.calendar_today),
                            ),
                            IconButton(
                              onPressed: _showSortOptions,
                              icon: const Icon(Icons.sort),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), 
                    _selectedDate != null && incompleteTasks.isEmpty ? const Text("No tasks :)", textAlign: TextAlign.center,) : 
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: incompleteTasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: ValueKey(incompleteTasks[index].id),
                          onDismissed: (direction) {
                            _removeTask(incompleteTasks[index]);
                          },
                          child: TaskItem(task: incompleteTasks[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              if(search.isNotEmpty && completedTasks.isNotEmpty || search.isEmpty)
              completedTasks.isEmpty ? const SizedBox(): 
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed Tasks (${completedTasks.length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: completedTasks.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: ValueKey(completedTasks[index].id),
                          onDismissed: (direction) {
                            _removeTask(completedTasks[index]);
                          },
                          child: CompleteTaskItem(task: completedTasks[index]),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
