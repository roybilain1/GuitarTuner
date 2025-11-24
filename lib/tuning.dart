import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Tuning extends StatefulWidget {
  @override
  State<Tuning> createState() => _TuningState();
}

class _TuningState extends State<Tuning> {
  // size of the middle image
  final double imageWidth = 500;
  final double imageHeight = 600;

  final AudioPlayer _player = AudioPlayer();
  String? selectedString;
  bool isPlaying = false;

  // Map string names to sound asset paths
  final Map<String, String> stringSounds = {
    'Low E': 'sounds/LowE.mp3',
    'A': 'sounds/A.mp3',
    'D': 'sounds/D.mp3',
    'G': 'sounds/G.mp3',
    'B': 'sounds/B.mp3',
    'High E': 'sounds/HighE.mp3',
  };

  // Map string names to button positions (adjust these for your image!)
  final Map<String, Offset> buttonPositions = {
    'Low E': Offset(55, 455),
    'A': Offset(80, 365),
    'D': Offset(100, 270),
    'G': Offset(122, 185),
    'B': Offset(145, 100),
    'High E': Offset(170, 10),
  };

  // Map string names to button labels
  final Map<String, String> buttonLabels = {
    'Low E': 'E',
    'A': 'A',
    'D': 'D',
    'G': 'G',
    'B': 'B',
    'High E': 'e',
  };

  // Play the note for the selected string
  void _playNote(String stringName) async {
    await _player.stop();
    await _player.play(AssetSource(stringSounds[stringName]!));
    setState(() {
      selectedString = stringName;
      isPlaying = true;
    });
  }

  // Stop playing the note
  void _stopNote() async {
    await _player.stop();
    setState(() {
      isPlaying = false;
      selectedString = null;
    });
  }

  // Info button
  void _showStringInfo(BuildContext context) {
    if (selectedString == null) return;
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
            Text(
              _stringFrequencies(selectedString!),
              style: TextStyle(fontSize: 16),
            ),
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

  // String frequency info
  String _stringFrequencies(String stringName) {
    switch (stringName) {
      case 'Low E':
        return 'Frequency: 82.41 Hz';
      case 'A':
        return 'Frequency: 110 Hz';
      case 'D':
        return 'Frequency: 146.83 Hz';
      case 'G':
        return 'Frequency: 196 Hz';
      case 'B':
        return 'Frequency: 246.94 Hz';
      case 'High E':
        return 'Frequency: 329.63 Hz';
      default:
        return '';
    }
  }

  // String quote info
  String _stringQuote(String stringName) {
    switch (stringName) {
      case 'Low E':
        return '"Tune up slowly – the thick string responds slower."';
      case 'A':
        return '"Recheck after tuning D & E strings."';
      case 'D':
        return '"Keep it steady."';
      case 'G':
        return '"Most unstable string, tune with care."';
      case 'B':
        return '"Hardest to intonate perfectly"';
      case 'High E':
        return '"Breaks easily if turned too fast. Tune slowly."';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final showScroll = screenWidth < imageWidth || screenHeight < imageHeight;

    Widget content = SizedBox(
      width: imageWidth,
      height: imageHeight,
      child: Stack(
        children: [
          // Fixed-size background image
          Positioned.fill(
            child: Transform.scale(
              scale: 1.5, // Increase for more zoom, decrease for less
              child: Image.asset(
                'assets/images/headstock.png',
                fit: BoxFit.fill,
              ),
            ),
          ),

          // Tuning key buttons
          ...buttonPositions.entries.map((entry) {
            final stringName = entry.key;
            final pos = entry.value;
            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.all(0),
                  elevation: 6,
                ),
                onPressed: () => _playNote(stringName),
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    buttonLabels[stringName]!,
                    style: TextStyle(
                      color: Color(0xFF800020),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Info button (bottom left)
          if (selectedString != null)
            Positioned(
              left: 24,
              bottom: 0,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF800020),
                onPressed: () => _showStringInfo(context),
                child: Icon(Icons.info, color: Colors.white),
                tooltip: 'String Info',
              ),
            ),

          // Stop button (bottom right)
          if (isPlaying)
            Positioned(
              right: 24,
              bottom: 0,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF800020),
                onPressed: _stopNote,
                child: Icon(Icons.stop, color: Colors.white),
                tooltip: 'Stop Sound',
              ),
            ),

          // Current string display (bottom center)
          if (selectedString != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  'Playing: $selectedString',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Guitar Tuning Helper 🎸'),
        centerTitle: true,
        backgroundColor: Color(0xFF800020),
        toolbarHeight: 90,
        elevation: 4,
      ),
      backgroundColor: Color(0xFF800020),
      body: Center(
        child: showScroll
            // if screen is smaller than image, enable scrolling
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: content,
                ),
              )
            : content, //This content is all the application
      ),
    );
  }
}
