import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingSongId;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _playingSongId = null;
        _currentPosition = Duration.zero;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Sample songs data - this will later come from your backend/database
  List<Song> songs = [
    Song(
      id: 1,
      title: "Amara",
      artist: "Fayrouz",
      chords: ["C", "F", "G"],
      audioPath: "songs/amara.mp3", // Add your audio file here
      isFavorite: false,
    ),
    Song(
      id: 2,
      title: "Hotel California",
      artist: "Eagles",
      chords: ["Am", "E7", "G", "D", "F", "C", "Dm", "E7"],
      audioPath: "songs/hotel_california.mp3",
      isFavorite: false,
    ),
    Song(
      id: 3,
      title: "Wish You Were Here",
      artist: "Pink Floyd",
      chords: ["C", "D", "Am", "G", "D", "C", "Am", "G"],
      audioPath: "songs/wish_you_were_here.mp3",
      isFavorite: false,
    ),
    Song(
      id: 4,
      title: "Sweet Child O' Mine",
      artist: "Guns N' Roses",
      chords: ["D", "C", "G", "D", "C", "G", "D", "C", "G", "F", "G"],
      audioPath: "songs/sweet_child_o_mine.mp3",
      isFavorite: false,
    ),
    Song(
      id: 5,
      title: "Shayef",
      artist: "Adonis",
      chords: ["A", "B", "E", "G#m", "F#m"],
      audioPath: "songs/shayef.mp3",
      isFavorite: false,
    ),
    Song(
      id: 6,
      title: "Stairway to Heaven",
      artist: "Led Zeppelin",
      chords: ["Am", "C", "D", "F", "G", "Am", "C", "D", "F", "Am"],
      audioPath: "songs/stairway_to_heaven.mp3",
      isFavorite: false,
    ),
    Song(
      id: 7,
      title: "Estesna'i",
      artist: "Adonis",
      chords: ["E", "G#m", "A", "B", "A", "E", "C#m7", "B"],
      audioPath: "songs/estesnai.mp3",
      isFavorite: false,
    ),
    Song(
      id: 8,
      title: "Nothing Else Matters",
      artist: "Metallica",
      chords: ["Em", "Am", "C", "D", "Em", "Am", "C", "D", "G", "B7"],
      audioPath: "songs/nothing_else_matters.mp3",
      isFavorite: false,
    ),
    Song(
      id: 9,
      title: "Creep",
      artist: "Radiohead",
      chords: ["G", "B", "C", "Cm", "G", "B", "C", "Cm"],
      audioPath: "songs/creep.mp3",
      isFavorite: false,
    ),
    Song(
      id: 10,
      title: "Law Baddak Yani",
      artist: "Adonis",
      chords: ["C", "Em", "Am", "G", "Em", "F", "Dm", "G", "F", "C", "G"],
      audioPath: "songs/law_baddak_yani.mp3",
      isFavorite: false,
    ),
  ];

  void _toggleFavorite(int songId) {
    setState(() {
      final song = songs.firstWhere((s) => s.id == songId);
      song.isFavorite = !song.isFavorite;
    });
  }

  Future<void> _playPauseSong(Song song) async {
    if (_playingSongId == song.id && _isPlaying) {
      // Pause current song
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else if (_playingSongId == song.id && !_isPlaying) {
      // Resume current song
      await _audioPlayer.resume();
      setState(() {
        _isPlaying = true;
      });
    } else {
      // Play new song
      if (song.audioPath != null) {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource(song.audioPath!));
        setState(() {
          _playingSongId = song.id;
          _isPlaying = true;
        });
      }
    }
  }

  Future<void> _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      _playingSongId = null;
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showChordDiagram(BuildContext context, String chord) {
    // Clean chord name for file lookup (remove special characters)
    String cleanChordName = chord.replaceAll(RegExp(r'[^A-Za-z0-9#b]'), '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$chord Chord',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF800020),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildChordDiagram(cleanChordName),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Tap and hold to practice this chord',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChordDiagram(String chordName) {
    // Try to load the chord diagram image
    String imagePath = 'assets/chords/${chordName.toLowerCase()}.png';

    return FutureBuilder(
      future: _checkAssetExists(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        bool assetExists = snapshot.data == true;

        if (assetExists) {
          return Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderDiagram(chordName);
            },
          );
        } else {
          return _buildPlaceholderDiagram(chordName);
        }
      },
    );
  }

  Future<bool> _checkAssetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildPlaceholderDiagram(String chordName) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.grey[100]!],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 48, color: Color(0xFF800020)),
          SizedBox(height: 16),
          Text(
            chordName,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF800020),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Chord Diagram',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Diagram coming soon!',
              style: TextStyle(fontSize: 12, color: Colors.orange[700]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Songs & Chords 🎵'),
        centerTitle: true,
        backgroundColor: Color(0xFF800020),
        elevation: 4,
        toolbarHeight: 90,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF800020),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              song.artist,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          song.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: song.isFavorite ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                        onPressed: () => _toggleFavorite(song.id),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Chords:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: song.chords.map((chord) {
                      return GestureDetector(
                        onTap: () => _showChordDiagram(context, chord),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF800020),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                chord,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.touch_app,
                                color: Colors.white70,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  // Audio Controls Section
                  if (song.audioPath != null) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                song.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      (_playingSongId == song.id && _isPlaying)
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Color(0xFF800020),
                                    ),
                                    onPressed: () => _playPauseSong(song),
                                  ),
                                  if (_playingSongId == song.id)
                                    IconButton(
                                      icon: Icon(
                                        Icons.stop,
                                        color: Color(0xFF800020),
                                      ),
                                      onPressed: _stopSong,
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (_playingSongId == song.id) ...[
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: _totalDuration.inMilliseconds > 0
                                  ? _currentPosition.inMilliseconds /
                                        _totalDuration.inMilliseconds
                                  : 0.0,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF800020),
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  _formatDuration(_totalDuration),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Song {
  final int id;
  final String title;
  final String artist;
  final List<String> chords;
  final String? audioPath; // Path to audio file
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.chords,
    this.audioPath,
    this.isFavorite = false,
  });
}
