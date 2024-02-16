import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/state/themeProvider.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ThemeMode theme = ref.watch(themeProvider);
    return Switch(
      value: theme == ThemeMode.dark,
      onChanged: (value) => onToggleTheme(ref, value),
    );
  }

  void onToggleTheme(ref, value) {
    ref.read(themeProvider.notifier).toggleTheme(value);
  }
}
