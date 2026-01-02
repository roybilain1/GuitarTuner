// Quick script to initialize the database via backend API
const mysql = require("mysql2");
require('dotenv').config();

const dbConfig = {
  host: process.env.MYSQLHOST || "mysql.railway.internal",
  user: process.env.MYSQLUSER || "root",
  password: process.env.MYSQLPASSWORD || "GvNAfTEZCYaLVFLHHCnQquKooyhvuyEc",
  database: process.env.MYSQLDATABASE || "railway",
  port: process.env.MYSQLPORT || 3306,
  multipleStatements: true
};

console.log("🔧 Connecting to MySQL...");
console.log(`Host: ${dbConfig.host}`);
console.log(`Database: ${dbConfig.database}`);
console.log("");

const db = mysql.createConnection(dbConfig);

db.connect((err) => {
  if (err) {
    console.error("❌ Connection failed:", err.message);
    process.exit(1);
  }
  
  console.log("✅ Connected to MySQL!");
  console.log("");
  console.log("🔧 Initializing database...");
  
  const initSQL = `
    CREATE TABLE IF NOT EXISTS songs (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      artist VARCHAR(255) NOT NULL,
      chords TEXT NOT NULL,
      audio_path VARCHAR(255),
      is_favorite TINYINT(1) DEFAULT 0,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE IF NOT EXISTS chords (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(50) NOT NULL UNIQUE,
      image_path VARCHAR(255) NOT NULL,
      description TEXT,
      difficulty_level VARCHAR(50) DEFAULT 'Beginner'
    );

    INSERT INTO songs (title, artist, chords, audio_path, is_favorite) VALUES
    ('Amara', 'Fayrouz', 'C,F,G', 'songs/Amara_Ya_Amara.mp3', 1),
    ('Hotel California', 'Eagles', 'Am,E7,G,D,F,C,Dm,E7', 'songs/Hotel_California.mp3', 0),
    ('Wish You Were Here', 'Pink Floyd', 'C,D,Am,G,D,C,Am,G', 'songs/Wish_You_Were_Here.mp3', 0),
    ('Sweet Child O''Mine', 'Guns N'' Roses', 'D,C,G,D,C,G,D,C,G,F,G', 'songs/Sweet_Child_O''_Mine.mp3', 0),
    ('Shayef', 'Adonis', 'A,B,E,G#m,F#m', 'songs/Shayef.mp3', 0),
    ('Stairway to Heaven', 'Led Zeppelin', 'Am,C,D,F,G,Am,C,D,F,Am', 'songs/Stairway_To_Heaven.mp3', 0),
    ('Estesna''i', 'Adonis', 'E,G#m,A,B,A,E,C#m7,B', 'songs/Estesna''i.mp3', 0),
    ('Nothing Else Matters', 'Metallica', 'Em,Am,C,D,Em,Am,C,D,G,B7', 'songs/Nothing_Else_Matters.mp3', 0),
    ('Creep', 'Radiohead', 'G,B,C,Cm', 'songs/creep.mp3', 0),
    ('Law Baddak Yani', 'Adonis', 'C,Em,Am,G,Em,F,Dm,G,F,C,G', 'songs/Law_Baddak_Yani.mp3', 0);

    INSERT INTO chords (name, image_path, description, difficulty_level) VALUES
    ('C', 'assets/chords/c.png', 'C Major chord', 'Beginner'),
    ('D', 'assets/chords/d.png', 'D Major chord', 'Beginner'),
    ('E', 'assets/chords/e.png', 'E Major chord', 'Beginner'),
    ('F', 'assets/chords/f.png', 'F Major chord', 'Intermediate'),
    ('G', 'assets/chords/g.png', 'G Major chord', 'Beginner'),
    ('A', 'assets/chords/a.png', 'A Major chord', 'Beginner'),
    ('B', 'assets/chords/b.png', 'B Major chord', 'Intermediate'),
    ('Am', 'assets/chords/am.png', 'A Minor chord', 'Beginner'),
    ('Cm', 'assets/chords/cm.png', 'C Minor chord', 'Intermediate'),
    ('Dm', 'assets/chords/dm.png', 'D Minor chord', 'Beginner'),
    ('Em', 'assets/chords/em.png', 'E Minor chord', 'Beginner'),
    ('E7', 'assets/chords/e7.png', 'E Dominant 7th chord', 'Intermediate'),
    ('Em7', 'assets/chords/em7.png', 'E Minor 7th chord', 'Intermediate'),
    ('B7', 'assets/chords/b7.png', 'B Dominant 7th chord', 'Intermediate'),
    ('F#m', 'assets/chords/f#m.png', 'F# Minor chord', 'Intermediate'),
    ('G#m', 'assets/chords/g#m.png', 'G# Minor chord', 'Advanced'),
    ('C#m7', 'assets/chords/c#m7.png', 'C# Minor 7th chord', 'Advanced');
  `;

  db.query(initSQL, (err, results) => {
    if (err) {
      console.error("❌ Initialization failed:", err.message);
      db.end();
      process.exit(1);
    }
    
    console.log("✅ Database initialized successfully!");
    console.log("");
    console.log("Created tables:");
    console.log("  - songs (10 sample songs)");
    console.log("  - chords (17 chord diagrams)");
    console.log("");
    
    db.end();
    console.log("Connection closed.");
  });
});
