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
            child: Transform.scale(
              scale: 1.3, // Zoom in the picture
              child: Image.asset(
                'assets/images/headstock.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Low E string button
          Positioned(
            left: 40,
            top: 560,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () {
                // TODO: Add action for E string
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'E',
                  style: TextStyle(
                    color: Color(0xFF800020),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // A string button
          Positioned(
            left: 70,
            top: 460,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () {
                // TODO: Add action for E string
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'A',
                  style: TextStyle(
                    color: Color(0xFF800020),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // D string button
          Positioned(
            left: 90,
            top: 360,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () {
                // TODO: Add action for E string
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'D',
                  style: TextStyle(
                    color: Color(0xFF800020),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // G string button
          Positioned(
            left: 110,
            top: 260,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () {
                // TODO: Add action for E string
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'G',
                  style: TextStyle(
                    color: Color(0xFF800020),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // B string button
          Positioned(
            left: 130,
            top: 160,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () {
                // TODO: Add action for E string
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'B',
                  style: TextStyle(
                    color: Color(0xFF800020),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),

          // High E string button// Low E string button
          Positioned(
            left: 150,
            top: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () {
                // TODO: Add action for E string
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  'e',
                  style: TextStyle(
                    color: Color(0xFF800020),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
