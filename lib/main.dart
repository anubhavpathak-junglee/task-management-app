import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_manager/providers/theme_provider.dart';
import 'package:task_manager/utils/themes.dart';

import 'package:task_manager/views/screens/task_screen.dart';

void main() async {
  runApp(const ProviderScope(child: App(),));
} 

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: themeMode,
      home: const TaskScreen(),
    );
  }
}