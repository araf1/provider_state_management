import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'screens/task_manager_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => TaskProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF202C2A);
    const canvas = Color(0xFFF5F7F3);

    return MaterialApp(
      title: 'Daymark Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        splashFactory: InkRipple.splashFactory,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF19796D),
          brightness: Brightness.light,
        ).copyWith(surface: canvas),
        scaffoldBackgroundColor: canvas,
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF19796D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: canvas,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFDCE4DE)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF19796D), width: 1.5),
          ),
        ),
      ),
      home: const TaskManagerScreen(),
    );
  }
}
