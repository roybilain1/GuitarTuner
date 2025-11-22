import 'package:flutter/material.dart';

//flutter run -d edge

//flutter run lib/main.dart -d chrome

// if you write st you can get the stateful or the stateless widget

void main() {
  runApp(myApp());
}

const TextStyle basicStyle = TextStyle(color: Colors.white, fontSize: 30);

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Text('Hello Guitar Tuner', style: basicStyle)),
    );
  }
}
