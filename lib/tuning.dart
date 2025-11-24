import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Tuning extends StatefulWidget {
  @override
  State<Tuning> createState() => _TuningState();
}

class _TuningState extends State<Tuning> {
  final AudioPlayer _player = AudioPlayer();
  String? selectedString;
  bool isPlaying = false;

  // Reference image size (pixels)
  final double refWidth = 530;
  final double refHeight = 700;

  // Button positions as percentages of image size
  final Map<String, Offset> buttonPercents = {
    'E': Offset(70 / 500, 470 / 600),
    'A': Offset(95 / 500, 380 / 600),
    'D': Offset(120 / 500, 285 / 600),
    'G': Offset(140 / 500, 200 / 600),
    'B': Offset(165 / 500, 110 / 600),
    'e': Offset(188 / 500, 20 / 600),
  };

  // String sounds
  final Map<String, String> stringSounds = {
    'E': 'sounds/LowE.mp3',
    'A': 'sounds/A.mp3',
    'D': 'sounds/D.mp3',
    'G': 'sounds/G.mp3',
    'B': 'sounds/B.mp3',
    'e': 'sounds/HighE.mp3',
  };

  // Map string names to button positions (adjust these for your image!)
  final Map<String, Offset> buttonPositions = {
    'E': Offset(55, 455),
    'A': Offset(80, 365),
    'D': Offset(100, 270),
    'G': Offset(122, 185),
    'B': Offset(145, 100),
    'e': Offset(170, 10),
  };

  // Map string names to button labels
  final Map<String, String> buttonLabels = {
    'E': 'E',
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

  String _stringFrequencies(String stringName) {
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
        backgroundColor: Color(0xFF800020),
        toolbarHeight: 90,
        elevation: 4,
      ),
      backgroundColor: Color(0xFF800020),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Use the smallest of the available width/height to fit the image
            double imageWidth = constraints.maxWidth < refWidth
                ? constraints.maxWidth
                : refWidth;
            double imageHeight = constraints.maxHeight < refHeight
                ? constraints.maxHeight
                : refHeight;

            return SizedBox(
              width: imageWidth,
              height: imageHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Transform.scale(
                      scale: 1.5,
                      child: Image.asset(
                        'assets/images/headstock.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // Tuning key buttons (relative positioning)
                  ...buttonPercents.entries.map((entry) {
                    final stringName = entry.key;
                    final percent = entry.value;
                    return Positioned(
                      left: imageWidth * percent.dx - 22, // Center the button
                      top: imageHeight * percent.dy - 22,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.all(0),
                          elevation: 6,
                        ),
                        onPressed: () => _playNote(stringName),
                        child: Container(
                          width: 55,
                          height: 55,
                          alignment: Alignment.center,
                          child: Text(
                            stringName,
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
                      bottom: 24,
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
                      bottom: 24,
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
                      bottom: 24,
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
          },
        ),
      ),
    );
  }
}
