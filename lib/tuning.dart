import 'package:flutter/material.dart';

class Tuning extends StatefulWidget {
  const Tuning({super.key});

  @override
  State<Tuning> createState() => _TunningState();
}

class _TunningState extends State<Tuning> {
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/headstock.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
