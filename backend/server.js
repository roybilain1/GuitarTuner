const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const mysql = require("mysql2");
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());

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

// Get favorite songs (MUST be before /songs/:id)
app.get("/songs/favorites", (req, res) => {
  const sql = "SELECT * FROM songs WHERE is_favorite = 1 ORDER BY title";

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

// Get all chords
app.get("/chords", (req, res) => {
  const sql = "SELECT * FROM chords ORDER BY name";
  
  db.query(sql, (err, result) => {
    if (err) {
      console.error("Error fetching chords:", err);
      return res.status(500).json({ error: "Failed to fetch chords" });
    }

    res.json({
      success: true,
      data: result,
      count: result.length
    });
  });
});

// Get chord by name
app.get("/chords/:name", (req, res) => {
  const { name } = req.params;
  const sql = "SELECT * FROM chords WHERE name = ?";
  
  db.query(sql, [name], (err, result) => {
    if (err) {
      console.error("Error fetching chord:", err);
      return res.status(500).json({ error: "Failed to fetch chord" });
    }

    if (result.length === 0) {
      return res.status(404).json({ error: "Chord not found" });
    }

    res.json({
      success: true,
      data: result[0]
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



const PORT = process.env.PORT || 5001;
const HOST = process.env.HOST || '0.0.0.0';

app.listen(PORT, HOST, () => {
  console.log(`Guitar Tuner Backend running on ${HOST}:${PORT}`);
  console.log(`API Base URL: http://localhost:${PORT}`);
  console.log("");
  console.log("Available endpoints:");
  console.log("- GET    /                         - Health check");
  console.log("- GET    /songs                    - Get all songs");
  console.log("- GET    /songs/:id               - Get song by ID");
  console.log("- GET    /songs/favorites         - Get favorite songs");
  console.log("- PATCH  /songs/:id/favorite      - Toggle favorite status");
  console.log("- GET    /chords                  - Get all chords");
  console.log("- GET    /chords/:name            - Get chord by name");
});
