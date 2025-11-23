import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Tuning extends StatefulWidget {
  const Tuning({super.key});

  @override
  State<Tuning> createState() => _TunningState();
}

// stop button
// fix picture
// info button of which string is selected

class _TunningState extends State<Tuning> {
  final AudioPlayer _player = AudioPlayer();
  String? selectedString;
  bool isPlaying = false;

  void _playNote(String asset) async {
    await _player.stop();
    await _player.play(AssetSource(asset));
  }

  // The info section for each string
  void _showStringInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$selectedString String Info',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(_stringInfo(selectedString!), style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text(
              _stringQuote(selectedString!),
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Info frenquency for each string
  String _stringInfo(String stringName) {
    switch (stringName) {
      case 'E':
        return 'Frequency: 82.41 Hz';
      case 'A':
        return 'Frequency: 110 Hz';
      case 'D':
        return 'Frequency: 146.83 Hz';
      case 'G':
        return 'Frequency: 196 Hz';
      case 'B':
        return 'Frequency: 246.94 Hz';
      case 'e':
        return 'Frequency: 329.63 Hz';
      default:
        return '';
    }
  }

  // Quote for each string
  String _stringQuote(String stringName) {
    switch (stringName) {
      case 'E':
        return '"Tune up slowly – the thick string responds slower."';
      case 'A':
        return '"Recheck after tuning D & E strings."';
      case 'D':
        return '"Keep it steady."';
      case 'G':
        return '"Most unstable string, tune with care."';
      case 'B':
        return '"Hardest to intonate perfectly"';
      case 'e':
        return '"Breaks easily if turned too fast. Tune slowly."';
      default:
        return '';
    }
  }

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
            left: 30,
            top: 560,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () async {
                setState(() {
                  selectedString = 'E'; // or the correct string
                  isPlaying = true;
                });
                await _player.stop(); // Stop any currently playing sound
                await _player.play(
                  AssetSource('sounds/LowE.mp3'),
                ); // Play Low E sound
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
            left: 60,
            top: 460,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () async {
                setState(() {
                  selectedString = 'A'; // or the correct string
                  isPlaying = true;
                });
                await _player.stop(); // Stop any currently playing sound
                await _player.play(AssetSource('sounds/A.mp3')); // Play A sound
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
            left: 85,
            top: 355,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () async {
                setState(() {
                  selectedString = 'D'; // or the correct string
                  isPlaying = true;
                });
                await _player.stop(); // Stop any currently playing sound
                await _player.play(AssetSource('sounds/D.mp3')); // Play D sound
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
            left: 105,
            top: 255,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () async {
                setState(() {
                  selectedString = 'G'; // or the correct string
                  isPlaying = true;
                });
                await _player.stop(); // Stop any currently playing sound
                await _player.play(AssetSource('sounds/G.mp3')); // Play G sound
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
            left: 135,
            top: 160,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () async {
                setState(() {
                  selectedString = 'B'; // or the correct string
                  isPlaying = true;
                });
                await _player.stop(); // Stop any currently playing sound
                await _player.play(AssetSource('sounds/B.mp3')); // Play B sound
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
            left: 160,
            top: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(0),
                elevation: 6,
              ),
              onPressed: () async {
                setState(() {
                  selectedString = 'e'; // or the correct string
                  isPlaying = true;
                });
                await _player.stop(); // Stop any currently playing sound
                await _player.play(
                  AssetSource('sounds/HighE.mp3'),
                ); // Play High E sound
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

          if (selectedString != null)
            Positioned(
              left: 24,
              bottom: 24,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF800020),
                onPressed: () => _showStringInfo(context),
                child: Icon(Icons.info, color: Colors.white),
              ),
            ),

          // Stop button
          if (isPlaying)
            Positioned(
              right: 24,
              bottom: 24,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF800020),
                onPressed: () async {
                  await _player.stop();
                  setState(() {
                    isPlaying = false;
                  });
                },
                child: Icon(Icons.stop, color: Colors.white),
                tooltip: 'Stop Sound',
              ),
            ),
        ],
      ),
    );
  }
}
