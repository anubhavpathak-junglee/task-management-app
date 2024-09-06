import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task_provider.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<Search> {
  final TextEditingController _searchController = TextEditingController();

  void _triggerSearch() {
    ref.read(tasksNotifierProvider.notifier).setSearch(_searchController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: InputBorder.none,
              label: const Text("Search"),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton.filled(
                onPressed: _triggerSearch,
                icon: const Icon(Icons.arrow_right_alt),
              ),
            ),
            onSubmitted: (_) => _triggerSearch(),
          ),
        ),
      ),
    );
  }
}
