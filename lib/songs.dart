import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  // Backend API
  final String apiUrl = "http://localhost:5001/songs";
  List<Song> songs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
    fetchSongs(); // Fetch songs from backend
  }

  // Fetch songs from backend API
  Future<void> fetchSongs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      print("Fetching songs from: $apiUrl");
      final response = await http.get(Uri.parse(apiUrl));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final List<dynamic> songsData = data['data'];

          setState(() {
            songs = songsData
                .map((songJson) => Song.fromJson(songJson))
                .toList();
            isLoading = false;
          });

          print("Loaded ${songs.length} songs successfully");
        } else {
          throw Exception('API returned success: false');
        }
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching songs: $e");
      setState(() {
        errorMessage = "Error loading songs: $e";
        isLoading = false;
      });
    }
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

  // Helper function to get chord image path
  String? _getChordImagePath(String chord) {
    // Convert chord to lowercase for filename matching
    final chordLower = chord.toLowerCase();

    // Map of chord names to image filenames
    final chordImageMap = {
      'a': 'a.png',
      'am': 'am.png',
      'b': 'b.png',
      'b7': 'b7.png',
      'c': 'c.png',
      'cm': 'cm.png',
      'c#m7': 'c#m7.png',
      'd': 'd.png',
      'dm': 'dm.png',
      'e': 'e.png',
      'e7': 'e7.png',
      'em': 'em.png',
      'em7': 'em7.png',
      'f': 'f.png',
      'f#m': 'f#m.png',
      'g': 'g.png',
      'g#m': 'g#m.png',
    };

    final imageName = chordImageMap[chordLower];
    return imageName != null ? 'assets/chords/$imageName' : null;
  }

  // Show chord diagram in a popup
  void _showChordDiagram(String chord) {
    final imagePath = _getChordImagePath(chord);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chord,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF800020),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: 200,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.music_note,
                                      size: 48,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Chord diagram\nnot available',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.music_note,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Chord diagram\nnot available',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF800020),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
    } else {
      // Play new song or resume
      if (_playingSongId != song.id) {
        // Stop current song and play new one
        await _audioPlayer.stop();
        setState(() {
          _playingSongId = song.id;
          _currentPosition = Duration.zero;
        });

        if (song.audioPath != null) {
          try {
            await _audioPlayer.play(AssetSource(song.audioPath!));
            setState(() {
              _isPlaying = true;
            });
          } catch (e) {
            print('Error playing audio: $e');
            // Show error to user
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not play audio: ${song.title}')),
            );
          }
        }
      } else {
        // Resume current song
        await _audioPlayer.resume();
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchSongs,
            tooltip: 'Refresh Songs',
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF800020)),
            SizedBox(height: 16),
            Text(
              'Loading songs...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Error Loading Songs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchSongs,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF800020),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (songs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.music_note_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Songs Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Check your backend connection',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _toggleFavorite(song.id),
                          icon: Icon(
                            song.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: song.isFavorite ? Colors.red : Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _playPauseSong(song),
                          icon: Icon(
                            (_playingSongId == song.id && _isPlaying)
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_fill,
                            color: Color(0xFF800020),
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Chords section
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
                  runSpacing: 4,
                  children: song.chords.map((chord) {
                    return GestureDetector(
                      onTap: () => _showChordDiagram(chord),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF800020),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              chord,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.touch_app,
                              color: Colors.white,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Audio progress bar (show only if this song is playing)
                if (_playingSongId == song.id) ...[
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8,
                            ),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _currentPosition.inSeconds.toDouble(),
                            max: _totalDuration.inSeconds.toDouble(),
                            onChanged: (value) {
                              _audioPlayer.seek(
                                Duration(seconds: value.toInt()),
                              );
                            },
                            activeColor: Color(0xFF800020),
                            inactiveColor: Colors.grey[300],
                          ),
                        ),
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
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
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

  // Factory constructor to create Song from JSON (backend API response)
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as int,
      title: json['title'] as String,
      artist: json['artist'] as String,
      chords: List<String>.from(json['chords'] as List),
      audioPath: json['audio_path'] as String?,
      isFavorite: (json['is_favorite'] as int) == 1,
    );
  }
}
