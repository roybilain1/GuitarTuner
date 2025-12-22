const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const mysql = require("mysql2");
require('dotenv').config();

const app = express();

// Middleware
app.use(cors({
  origin: '*',
  credentials: false,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(bodyParser.json());

// Database connection
const db = mysql.createConnection({
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "guitartuner",
});

db.connect((err) => {
  if (err) {
    console.error("Database connection failed:", err);
    throw err;
  }
  console.log("MySQL Connected...");
});

// Routes

// Health check
app.get("/", (req, res) => {
  res.json({ message: "Guitar Tuner Backend API is running!" });
});

// Get all songs
app.get("/songs", (req, res) => {
  const sql = "SELECT id, title, artist, chords, audio_path, is_favorite FROM songs ORDER BY id DESC";
  
  db.query(sql, (err, result) => {
    if (err) {
      console.error("Error fetching songs:", err);
      return res.status(500).json({ error: "Failed to fetch songs" });
    }

    // Parse chords from comma-separated string to array
    const songs = result.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : []
    }));

    res.json({
      success: true,
      data: songs,
      count: songs.length
    });
  });
});

// Get song by ID
app.get("/songs/:id", (req, res) => {
  const { id } = req.params;
  const sql = "SELECT * FROM songs WHERE id = ?";
  
  db.query(sql, [id], (err, result) => {
    if (err) {
      console.error("Error fetching song:", err);
      return res.status(500).json({ error: "Failed to fetch song" });
    }

    if (result.length === 0) {
      return res.status(404).json({ error: "Song not found" });
    }

    // Parse chords from comma-separated string to array
    const song = {
      ...result[0],
      chords: result[0].chords ? result[0].chords.split(',') : []
    };

    res.json({
      success: true,
      data: song
    });
  });
});

// Create a new song
app.post("/songs", (req, res) => {
  const { title, artist, chords, audioPath, isFavorite } = req.body;

  // Validation
  if (!title || !artist) {
    return res.status(400).json({ error: "Title and artist are required" });
  }

  // Convert chords array to comma-separated string
  const chordsString = Array.isArray(chords) ? chords.join(',') : '';

  const sql = "INSERT INTO songs (title, artist, chords, audio_path, is_favorite) VALUES (?, ?, ?, ?, ?)";
  const values = [title, artist, chordsString, audioPath || null, isFavorite || false];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error("Error creating song:", err);
      return res.status(500).json({ error: "Failed to create song" });
    }

    res.status(201).json({
      success: true,
      message: "Song created successfully",
      data: {
        id: result.insertId,
        title,
        artist,
        chords: Array.isArray(chords) ? chords : [],
        audioPath: audioPath || null,
        isFavorite: isFavorite || false
      }
    });
  });
});

// Update a song
app.put("/songs/:id", (req, res) => {
  const { id } = req.params;
  const { title, artist, chords, audioPath, isFavorite } = req.body;

  // Convert chords array to comma-separated string
  const chordsString = Array.isArray(chords) ? chords.join(',') : '';

  const sql = "UPDATE songs SET title = ?, artist = ?, chords = ?, audio_path = ?, is_favorite = ? WHERE id = ?";
  const values = [title, artist, chordsString, audioPath, isFavorite, id];

  db.query(sql, values, (err, result) => {
    if (err) {
      console.error("Error updating song:", err);
      return res.status(500).json({ error: "Failed to update song" });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Song not found" });
    }

    res.json({
      success: true,
      message: "Song updated successfully",
      data: {
        id: parseInt(id),
        title,
        artist,
        chords: Array.isArray(chords) ? chords : [],
        audioPath,
        isFavorite
      }
    });
  });
});

// Delete a song
app.delete("/songs/:id", (req, res) => {
  const { id } = req.params;
  const sql = "DELETE FROM songs WHERE id = ?";

  db.query(sql, [id], (err, result) => {
    if (err) {
      console.error("Error deleting song:", err);
      return res.status(500).json({ error: "Failed to delete song" });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Song not found" });
    }

    res.json({
      success: true,
      message: "Song deleted successfully",
      deletedId: id
    });
  });
});

// Search songs by title or artist
app.get("/songs/search/:query", (req, res) => {
  const { query } = req.params;
  const sql = "SELECT * FROM songs WHERE title LIKE ? OR artist LIKE ? ORDER BY title";
  const searchQuery = `%${query}%`;

  db.query(sql, [searchQuery, searchQuery], (err, result) => {
    if (err) {
      console.error("Error searching songs:", err);
      return res.status(500).json({ error: "Failed to search songs" });
    }

    // Parse chords from comma-separated string to array
    const songs = result.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : []
    }));

    res.json({
      success: true,
      data: songs,
      count: songs.length
    });
  });
});

// Get songs by artist
app.get("/artists/:artist/songs", (req, res) => {
  const { artist } = req.params;
  const sql = "SELECT * FROM songs WHERE artist = ? ORDER BY title";

  db.query(sql, [artist], (err, result) => {
    if (err) {
      console.error("Error fetching songs by artist:", err);
      return res.status(500).json({ error: "Failed to fetch songs by artist" });
    }

    // Parse chords from comma-separated string to array
    const songs = result.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : []
    }));

    res.json({
      success: true,
      data: songs,
      count: songs.length
    });
  });
});

// Get favorite songs
app.get("/songs/favorites/list", (req, res) => {
  const sql = "SELECT * FROM songs WHERE is_favorite = TRUE ORDER BY title";

  db.query(sql, (err, result) => {
    if (err) {
      console.error("Error fetching favorite songs:", err);
      return res.status(500).json({ error: "Failed to fetch favorite songs" });
    }

    // Parse chords from comma-separated string to array
    const songs = result.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : []
    }));

    res.json({
      success: true,
      data: songs,
      count: songs.length
    });
  });
});

// Toggle favorite status
app.patch("/songs/:id/favorite", (req, res) => {
  const { id } = req.params;
  const sql = "UPDATE songs SET is_favorite = NOT is_favorite WHERE id = ?";

  db.query(sql, [id], (err, result) => {
    if (err) {
      console.error("Error toggling favorite:", err);
      return res.status(500).json({ error: "Failed to toggle favorite" });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: "Song not found" });
    }

    // Get updated song to return current favorite status
    const getSongSql = "SELECT id, title, is_favorite FROM songs WHERE id = ?";
    db.query(getSongSql, [id], (err, songResult) => {
      if (err) {
        return res.status(500).json({ error: "Failed to get updated song" });
      }

      res.json({
        success: true,
        message: "Favorite status updated",
        data: songResult[0]
      });
    });
  });
});

// Get songs by chord
app.get("/chords/:chord/songs", (req, res) => {
  const { chord } = req.params;
  
  // Using the normalized song_chords table
  const sql = `
    SELECT DISTINCT s.* 
    FROM songs s 
    JOIN song_chords sc ON s.id = sc.song_id 
    WHERE sc.chord = ? 
    ORDER BY s.title
  `;

  db.query(sql, [chord], (err, result) => {
    if (err) {
      console.error("Error fetching songs by chord:", err);
      return res.status(500).json({ error: "Failed to fetch songs by chord" });
    }

    // Parse chords from comma-separated string to array
    const songs = result.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : []
    }));

    res.json({
      success: true,
      data: songs,
      count: songs.length
    });
  });
});

const PORT = process.env.PORT || 5001;
app.listen(PORT, () => {
  console.log(`Guitar Tuner Backend running on port ${PORT}`);
  console.log(`API Base URL: http://localhost:${PORT}`);
  console.log("");
  console.log("Available endpoints:");
  console.log("- GET    /songs                     - Get all songs");
  console.log("- GET    /songs/:id                - Get song by ID");  
  console.log("- POST   /songs                    - Create new song");
  console.log("- PUT    /songs/:id                - Update song");
  console.log("- DELETE /songs/:id                - Delete song");
  console.log("- GET    /songs/search/:query      - Search songs");
  console.log("- GET    /artists/:artist/songs    - Get songs by artist");
  console.log("- GET    /songs/favorites/list     - Get favorite songs");
  console.log("- PATCH  /songs/:id/favorite       - Toggle favorite status");
  console.log("- GET    /chords/:chord/songs      - Get songs by chord");
});
