const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const sqlite3 = require("sqlite3").verbose();
const path = require("path");

const app = express();

// Middleware
app.use(cors({
  origin: '*',
  credentials: false,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(bodyParser.json());

// Database connection (SQLite)
const dbPath = path.join(__dirname, 'guitartuner.db');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error("Database connection failed:", err);
    throw err;
  }
  console.log("SQLite Database Connected...");
  
  // Create tables if they don't exist
  createTables();
});

function createTables() {
  // Create songs table
  db.run(`
    CREATE TABLE IF NOT EXISTS songs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      artist TEXT NOT NULL,
      chords TEXT NOT NULL,
      audio_path TEXT,
      is_favorite BOOLEAN DEFAULT 0,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `, (err) => {
    if (err) {
      console.error("Error creating songs table:", err);
    } else {
      console.log("Songs table ready");
      
      // Insert sample data if table is empty
      db.get("SELECT COUNT(*) as count FROM songs", (err, row) => {
        if (!err && row.count === 0) {
          insertSampleData();
        }
      });
    }
  });

  // Create indexes
  db.run("CREATE INDEX IF NOT EXISTS idx_artist ON songs(artist)");
  db.run("CREATE INDEX IF NOT EXISTS idx_title ON songs(title)");
  db.run("CREATE INDEX IF NOT EXISTS idx_is_favorite ON songs(is_favorite)");
}

function insertSampleData() {
  console.log("Inserting sample data...");
  
  const sampleSongs = [
    [1, 'Amara', 'Fayrouz', 'C,F,G', 'songs/amara.mp3', 0],
    [2, 'Hotel California', 'Eagles', 'Am,E7,G,D,F,C,Dm,E7', 'songs/hotel_california.mp3', 0],
    [3, 'Wish You Were Here', 'Pink Floyd', 'C,D,Am,G,D,C,Am,G', 'songs/wish_you_were_here.mp3', 0],
    [4, 'Sweet Child O\' Mine', 'Guns N\' Roses', 'D,C,G,D,C,G,D,C,G,F,G', 'songs/sweet_child_o_mine.mp3', 0],
    [5, 'Shayef', 'Adonis', 'A,B,E,G#m,F#m', 'songs/shayef.mp3', 0],
    [6, 'Stairway to Heaven', 'Led Zeppelin', 'Am,C,D,F,G,Am,C,D,F,Am', 'songs/stairway_to_heaven.mp3', 0],
    [7, 'Estesna\'i', 'Adonis', 'E,G#m,A,B,A,E,C#m7,B', 'songs/estesnai.mp3', 0],
    [8, 'Nothing Else Matters', 'Metallica', 'Em,Am,C,D,Em,Am,C,D,G,B7', 'songs/nothing_else_matters.mp3', 0],
    [9, 'Creep', 'Radiohead', 'G,B,C,Cm,G,B,C,Cm', 'songs/creep.mp3', 0],
    [10, 'Law Baddak Yani', 'Adonis', 'C,Em,Am,G,Em,F,Dm,G,F,C,G', 'songs/law_baddak_yani.mp3', 0]
  ];

  const stmt = db.prepare("INSERT INTO songs (id, title, artist, chords, audio_path, is_favorite) VALUES (?, ?, ?, ?, ?, ?)");
  
  sampleSongs.forEach(song => {
    stmt.run(song, (err) => {
      if (err) {
        console.error("Error inserting sample song:", err);
      }
    });
  });
  
  stmt.finalize(() => {
    console.log("Sample data inserted successfully!");
  });
}

// Routes

// Health check
app.get("/", (req, res) => {
  res.json({ message: "Guitar Tuner Backend API is running!" });
});

// Get all songs
app.get("/songs", (req, res) => {
  const sql = "SELECT id, title, artist, chords, audio_path, is_favorite, created_at, updated_at FROM songs ORDER BY created_at DESC";
  
  db.all(sql, [], (err, rows) => {
    if (err) {
      console.error("Error fetching songs:", err);
      return res.status(500).json({ error: "Failed to fetch songs" });
    }

    // Parse chords from comma-separated string to array
    const songs = rows.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : [],
      is_favorite: Boolean(song.is_favorite)
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
  
  db.get(sql, [id], (err, row) => {
    if (err) {
      console.error("Error fetching song:", err);
      return res.status(500).json({ error: "Failed to fetch song" });
    }

    if (!row) {
      return res.status(404).json({ error: "Song not found" });
    }

    // Parse chords from comma-separated string to array
    const song = {
      ...row,
      chords: row.chords ? row.chords.split(',') : [],
      is_favorite: Boolean(row.is_favorite)
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
  const values = [title, artist, chordsString, audioPath || null, isFavorite ? 1 : 0];

  db.run(sql, values, function(err) {
    if (err) {
      console.error("Error creating song:", err);
      return res.status(500).json({ error: "Failed to create song" });
    }

    res.status(201).json({
      success: true,
      message: "Song created successfully",
      data: {
        id: this.lastID,
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

  const sql = "UPDATE songs SET title = ?, artist = ?, chords = ?, audio_path = ?, is_favorite = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
  const values = [title, artist, chordsString, audioPath, isFavorite ? 1 : 0, id];

  db.run(sql, values, function(err) {
    if (err) {
      console.error("Error updating song:", err);
      return res.status(500).json({ error: "Failed to update song" });
    }

    if (this.changes === 0) {
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

  db.run(sql, [id], function(err) {
    if (err) {
      console.error("Error deleting song:", err);
      return res.status(500).json({ error: "Failed to delete song" });
    }

    if (this.changes === 0) {
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

  db.all(sql, [searchQuery, searchQuery], (err, rows) => {
    if (err) {
      console.error("Error searching songs:", err);
      return res.status(500).json({ error: "Failed to search songs" });
    }

    // Parse chords from comma-separated string to array
    const songs = rows.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : [],
      is_favorite: Boolean(song.is_favorite)
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

  db.all(sql, [artist], (err, rows) => {
    if (err) {
      console.error("Error fetching songs by artist:", err);
      return res.status(500).json({ error: "Failed to fetch songs by artist" });
    }

    // Parse chords from comma-separated string to array
    const songs = rows.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : [],
      is_favorite: Boolean(song.is_favorite)
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
  const sql = "SELECT * FROM songs WHERE is_favorite = 1 ORDER BY title";

  db.all(sql, [], (err, rows) => {
    if (err) {
      console.error("Error fetching favorite songs:", err);
      return res.status(500).json({ error: "Failed to fetch favorite songs" });
    }

    // Parse chords from comma-separated string to array
    const songs = rows.map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : [],
      is_favorite: Boolean(song.is_favorite)
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
  
  // First get current favorite status
  db.get("SELECT is_favorite FROM songs WHERE id = ?", [id], (err, row) => {
    if (err) {
      console.error("Error getting song:", err);
      return res.status(500).json({ error: "Failed to get song" });
    }
    
    if (!row) {
      return res.status(404).json({ error: "Song not found" });
    }
    
    // Toggle the favorite status
    const newFavoriteStatus = row.is_favorite ? 0 : 1;
    const sql = "UPDATE songs SET is_favorite = ? WHERE id = ?";

    db.run(sql, [newFavoriteStatus, id], function(err) {
      if (err) {
        console.error("Error toggling favorite:", err);
        return res.status(500).json({ error: "Failed to toggle favorite" });
      }

      // Get updated song to return current favorite status
      db.get("SELECT id, title, is_favorite FROM songs WHERE id = ?", [id], (err, updatedRow) => {
        if (err) {
          return res.status(500).json({ error: "Failed to get updated song" });
        }

        res.json({
          success: true,
          message: "Favorite status updated",
          data: {
            ...updatedRow,
            is_favorite: Boolean(updatedRow.is_favorite)
          }
        });
      });
    });
  });
});

// Get songs by chord
app.get("/chords/:chord/songs", (req, res) => {
  const { chord } = req.params;
  
  // Search for songs that contain the chord in their chords string
  const sql = `SELECT * FROM songs WHERE chords LIKE ? ORDER BY title`;
  const searchQuery = `%${chord}%`;

  db.all(sql, [searchQuery], (err, rows) => {
    if (err) {
      console.error("Error fetching songs by chord:", err);
      return res.status(500).json({ error: "Failed to fetch songs by chord" });
    }

    // Filter to ensure exact chord match (not substring)
    const songs = rows.filter(song => {
      const songChords = song.chords ? song.chords.split(',') : [];
      return songChords.includes(chord);
    }).map(song => ({
      ...song,
      chords: song.chords ? song.chords.split(',') : [],
      is_favorite: Boolean(song.is_favorite)
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
