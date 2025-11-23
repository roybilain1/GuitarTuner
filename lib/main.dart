import 'package:flutter/material.dart';
import 'package:guitartuner/home.dart';

// flutter run lib/main.dart -d chrome

void main() => runApp(GuitarTunerApp());

class GuitarTunerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guitar Tuning Helper 🎸',
      theme: ThemeData(
        primaryColor: Color(0xFF800020), // Bordo color
        scaffoldBackgroundColor: Colors.white, // White background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF800020), // Bordo
          foregroundColor: Colors.white,
          elevation: 4,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
