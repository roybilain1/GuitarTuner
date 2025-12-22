-- Create database (if using MySQL/PostgreSQL)
-- CREATE DATABASE guitartuner;
-- USE guitartuner;

-- Create songs table
CREATE TABLE songs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist VARCHAR(255) NOT NULL,
    chords TEXT NOT NULL,  -- Store chords as comma-separated string
    audio_path VARCHAR(500),
    is_favorite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert the sample data
INSERT INTO songs (id, title, artist, chords, audio_path, is_favorite) VALUES
(1, 'Amara', 'Fayrouz', 'C,F,G', 'songs/amara.mp3', FALSE),
(2, 'Hotel California', 'Eagles', 'Am,E7,G,D,F,C,Dm,E7', 'songs/hotel_california.mp3', FALSE),
(3, 'Wish You Were Here', 'Pink Floyd', 'C,D,Am,G,D,C,Am,G', 'songs/wish_you_were_here.mp3', FALSE),
(4, 'Sweet Child O'' Mine', 'Guns N'' Roses', 'D,C,G,D,C,G,D,C,G,F,G', 'songs/sweet_child_o_mine.mp3', FALSE),
(5, 'Shayef', 'Adonis', 'A,B,E,G#m,F#m', 'songs/shayef.mp3', FALSE),
(6, 'Stairway to Heaven', 'Led Zeppelin', 'Am,C,D,F,G,Am,C,D,F,Am', 'songs/stairway_to_heaven.mp3', FALSE),
(7, 'Estesna''i', 'Adonis', 'E,G#m,A,B,A,E,C#m7,B', 'songs/estesnai.mp3', FALSE),
(8, 'Nothing Else Matters', 'Metallica', 'Em,Am,C,D,Em,Am,C,D,G,B7', 'songs/nothing_else_matters.mp3', FALSE),
(9, 'Creep', 'Radiohead', 'G,B,C,Cm,G,B,C,Cm', 'songs/creep.mp3', FALSE),
(10, 'Law Baddak Yani', 'Adonis', 'C,Em,Am,G,Em,F,Dm,G,F,C,G', 'songs/law_baddak_yani.mp3', FALSE);

-- Optional: Create indexes for better performance
CREATE INDEX idx_artist ON songs(artist);
CREATE INDEX idx_title ON songs(title);
CREATE INDEX idx_is_favorite ON songs(is_favorite);

-- Optional: Create a separate chords table for normalized structure
CREATE TABLE song_chords (
    id INT AUTO_INCREMENT PRIMARY KEY,
    song_id INT NOT NULL,
    chord VARCHAR(10) NOT NULL,
    chord_position INT NOT NULL,
    FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE,
    INDEX idx_song_id (song_id),
    INDEX idx_chord (chord)
);

-- Insert normalized chord data
INSERT INTO song_chords (song_id, chord, chord_position) VALUES
-- Song 1: Amara
(1, 'C', 1), (1, 'F', 2), (1, 'G', 3),

-- Song 2: Hotel California  
(2, 'Am', 1), (2, 'E7', 2), (2, 'G', 3), (2, 'D', 4), (2, 'F', 5), (2, 'C', 6), (2, 'Dm', 7), (2, 'E7', 8),

-- Song 3: Wish You Were Here
(3, 'C', 1), (3, 'D', 2), (3, 'Am', 3), (3, 'G', 4), (3, 'D', 5), (3, 'C', 6), (3, 'Am', 7), (3, 'G', 8),

-- Song 4: Sweet Child O' Mine
(4, 'D', 1), (4, 'C', 2), (4, 'G', 3), (4, 'D', 4), (4, 'C', 5), (4, 'G', 6), (4, 'D', 7), (4, 'C', 8), (4, 'G', 9), (4, 'F', 10), (4, 'G', 11),

-- Song 5: Shayef
(5, 'A', 1), (5, 'B', 2), (5, 'E', 3), (5, 'G#m', 4), (5, 'F#m', 5),

-- Song 6: Stairway to Heaven
(6, 'Am', 1), (6, 'C', 2), (6, 'D', 3), (6, 'F', 4), (6, 'G', 5), (6, 'Am', 6), (6, 'C', 7), (6, 'D', 8), (6, 'F', 9), (6, 'Am', 10),

-- Song 7: Estesna'i
(7, 'E', 1), (7, 'G#m', 2), (7, 'A', 3), (7, 'B', 4), (7, 'A', 5), (7, 'E', 6), (7, 'C#m7', 7), (7, 'B', 8),

-- Song 8: Nothing Else Matters
(8, 'Em', 1), (8, 'Am', 2), (8, 'C', 3), (8, 'D', 4), (8, 'Em', 5), (8, 'Am', 6), (8, 'C', 7), (8, 'D', 8), (8, 'G', 9), (8, 'B7', 10),

-- Song 9: Creep
(9, 'G', 1), (9, 'B', 2), (9, 'C', 3), (9, 'Cm', 4), (9, 'G', 5), (9, 'B', 6), (9, 'C', 7), (9, 'Cm', 8),

-- Song 10: Law Baddak Yani
(10, 'C', 1), (10, 'Em', 2), (10, 'Am', 3), (10, 'G', 4), (10, 'Em', 5), (10, 'F', 6), (10, 'Dm', 7), (10, 'G', 8), (10, 'F', 9), (10, 'C', 10), (10, 'G', 11);

-- Some useful queries for your application:

-- Get all songs with their chords as comma-separated string
-- SELECT id, title, artist, chords, audio_path, is_favorite FROM songs;

-- Get a specific song with its chords array (for normalized structure)
-- SELECT s.id, s.title, s.artist, s.audio_path, s.is_favorite,
--        GROUP_CONCAT(sc.chord ORDER BY sc.chord_position) as chords
-- FROM songs s
-- LEFT JOIN song_chords sc ON s.id = sc.song_id
-- WHERE s.id = 1
-- GROUP BY s.id;

-- Search songs by title or artist
-- SELECT * FROM songs WHERE title LIKE '%hotel%' OR artist LIKE '%eagles%';

-- Get songs by specific chord
-- SELECT DISTINCT s.* FROM songs s
-- JOIN song_chords sc ON s.id = sc.song_id
-- WHERE sc.chord = 'G';

-- Get favorite songs
-- SELECT * FROM songs WHERE is_favorite = TRUE;
