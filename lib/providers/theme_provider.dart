import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeMode = prefs.getString('theme_mode');
    if (themeMode != null) {
      state = themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
  }

  Future<void> toggleTheme() async {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', state == ThemeMode.dark ? 'dark' : 'light');
  }
}
