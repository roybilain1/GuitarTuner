import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guitar Tuning Helper 🎸'),
        centerTitle: true,
        toolbarHeight: 90,
      ),
      body: Stack(
        children: [
          // Full background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/headstock.png',
              fit: BoxFit.cover,
            ),
          ),
          // Your content goes here, for example:
          Center(
            child: Text(
              'Welcome!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black54,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
