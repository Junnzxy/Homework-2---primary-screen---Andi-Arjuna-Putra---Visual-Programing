import 'package:flutter/material.dart';

import 'screens/smart_home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoHome Smart Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF287A56),
          tertiary: const Color(0xFFD18A2D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F8F4),
        useMaterial3: true,
      ),
      home: const SmartHomeScreen(),
    );
  }
}
