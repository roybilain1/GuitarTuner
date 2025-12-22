import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingSongId;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Backend API
  final String apiUrl = "http://localhost:5001/songs";
  final String chordsApiUrl = "http://localhost:5001/chords";
  List<Song> favoriteSongs = [];
  Map<String, Chord> chordMap = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeAudioPlayer();
    fetchChords();
    fetchFavoriteSongs();
  }

  void _initializeAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _currentPosition = Duration.zero;
      });
    });
  }

  // Fetch chords from backend API
  Future<void> fetchChords() async {
    try {
      final response = await http.get(Uri.parse(chordsApiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] is List) {
          final List<dynamic> chordsData = data['data'];
          setState(() {
            chordMap = {
              for (var chordJson in chordsData)
                chordJson['name']: Chord.fromJson(chordJson),
            };
          });
        }
      }
    } catch (e) {
      print('Error fetching chords: $e');
    }
  }

  // Fetch favorite songs from backend API
  Future<void> fetchFavoriteSongs() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(Uri.parse("$apiUrl/favorites"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] is List) {
          final List<dynamic> songsData = data['data'];
          setState(() {
            favoriteSongs = songsData
                .map((songJson) => Song.fromJson(songJson))
                .toList();
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load favorite songs';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _removeFavorite(int songId) async {
    try {
      final response = await http.patch(
        Uri.parse("$apiUrl/$songId/favorite"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            favoriteSongs.removeWhere((song) => song.id == songId);
          });

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Removed from favorites')));
        }
      } else {
        throw Exception('Failed to remove favorite');
      }
    } catch (e) {
      print('Error removing favorite: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating favorite status')));
    }
  }

  Future<void> _playPauseSong(Song song) async {
    if (_playingSongId == song.id && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      if (_playingSongId != song.id) {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not play audio: ${song.title}')),
            );
          }
        }
      } else {
        await _audioPlayer.resume();
        setState(() {
          _isPlaying = true;
        });
      }
    }
  }

  String? _getChordImagePath(String chord) {
    final chordData = chordMap[chord];
    return chordData?.imagePath;
  }

  void _showChordDiagram(String chord) {
    final chordData = chordMap[chord];
    final imagePath = chordData?.imagePath ?? _getChordImagePath(chord);

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
                if (chordData?.description != null) ...[
                  SizedBox(height: 8),
                  Text(
                    chordData!.description!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
                if (chordData != null &&
                    chordData.difficultyLevel.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(chordData.difficultyLevel),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chordData.difficultyLevel,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
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
        title: Text('Favorite Songs'),
        backgroundColor: Color(0xFF800020),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF800020)))
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error Loading Favorites',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: fetchFavoriteSongs,
                    child: Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF800020),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : favoriteSongs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No Favorite Songs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start adding songs to your favorites!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchFavoriteSongs,
              color: Color(0xFF800020),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: favoriteSongs.length,
                itemBuilder: (context, index) {
                  final song = favoriteSongs[index];
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
                                    onPressed: () => _removeFavorite(song.id),
                                    icon: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Remove from favorites',
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
                                      value: _currentPosition.inSeconds
                                          .toDouble(),
                                      max: _totalDuration.inSeconds.toDouble(),
                                      onChanged: (value) => _audioPlayer.seek(
                                        Duration(seconds: value.toInt()),
                                      ),
                                      activeColor: Color(0xFF800020),
                                      inactiveColor: Colors.grey[300],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
              ),
            ),
    );
  }
}

// Reuse the same Song and Chord classes from songs.dart
class Song {
  final int id;
  final String title;
  final String artist;
  final List<String> chords;
  final String? audioPath;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.chords,
    this.audioPath,
    this.isFavorite = false,
  });

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

class Chord {
  final int id;
  final String name;
  final String imagePath;
  final String? description;
  final String difficultyLevel;

  Chord({
    required this.id,
    required this.name,
    required this.imagePath,
    this.description,
    required this.difficultyLevel,
  });

  factory Chord.fromJson(Map<String, dynamic> json) {
    return Chord(
      id: json['id'] as int,
      name: json['name'] as String,
      imagePath: json['image_path'] as String,
      description: json['description'] as String?,
      difficultyLevel: json['difficulty_level'] as String,
    );
  }
}
