-- Railway Database Initialization Script
-- Guitar Tuner Backend Database

-- Create songs table
CREATE TABLE IF NOT EXISTS songs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  artist VARCHAR(255) NOT NULL,
  chords TEXT NOT NULL,
  audio_path VARCHAR(255),
  is_favorite TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create chords table
CREATE TABLE IF NOT EXISTS chords (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  image_path VARCHAR(255) NOT NULL,
  description TEXT,
  difficulty_level VARCHAR(50) DEFAULT 'Beginner'
);

-- Insert sample songs
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

-- Insert chords
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
