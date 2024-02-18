import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/router/router.dart';
import 'package:hear_ai_demo/state/providers.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeMode themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      routerConfig: router,
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
