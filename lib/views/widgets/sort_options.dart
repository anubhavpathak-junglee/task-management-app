import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task_provider.dart';

class SortOptions extends ConsumerWidget {
  const SortOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortBy = ref.watch(tasksNotifierProvider.notifier).sortBy;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Sort by due date'),
          trailing: sortBy["dueDate"]! ? const Icon(Icons.check) : null,
          onTap: () {
            ref.read(tasksNotifierProvider.notifier).toggleSortBy("dueDate");
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.priority_high),
          title: const Text('Sort by priority'),
          trailing: sortBy["priority"]! ? const Icon(Icons.check) : null,
          onTap: () {
            ref.read(tasksNotifierProvider.notifier).toggleSortBy("priority");
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Sort by created date'),
          trailing: sortBy["createdAt"]! ? const Icon(Icons.check) : null,
          onTap: () {
            ref.read(tasksNotifierProvider.notifier).toggleSortBy("createdAt");
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
