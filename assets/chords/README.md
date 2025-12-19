# Guitar Chord Diagrams

This folder contains chord diagram images for the guitar tuner app.

## Required Chord Diagram Files:

Add chord diagram images (PNG format, 300x400 pixels recommended) with these names:

### Basic Chords:
- `c.png` - C Major
- `d.png` - D Major  
- `e.png` - E Major
- `f.png` - F Major
- `g.png` - G Major
- `a.png` - A Major
- `b.png` - B Major

### Minor Chords:
- `am.png` - A Minor
- `em.png` - E Minor
- `dm.png` - D Minor
- `cm.png` - C Minor
- `gm.png` - G Minor
- `fm.png` - F Minor
- `bm.png` - B Minor

### Seventh Chords:
- `a7.png` - A7
- `b7.png` - B7
- `d7.png` - D7
- `e7.png` - E7
- `g7.png` - G7

### Extended Chords:
- `am7.png` - Am7
- `cadd9.png` - Cadd9
- `em7.png` - Em7
- `gb.png` - G/B (G over B)

## File Naming Convention:
- Use lowercase for all chord names
- Remove special characters: `Em7` becomes `em7.png`
- Slash chords: `G/B` becomes `gb.png`
- Sharp chords: `F#` becomes `fsharp.png`
- Flat chords: `Bb` becomes `bb.png`

## Image Specifications:
- **Format**: PNG (transparent background preferred)
- **Size**: 300x400 pixels (or similar 3:4 ratio)
- **Style**: Clear fret diagrams with:
  - Fret positions marked
  - Finger positions numbered (1,2,3,4)
  - Open strings marked with 'O'
  - Muted strings marked with 'X'

## Sources for Chord Diagrams:
You can create or source diagrams from:
- **Free Resources**: 
  - Ultimate Guitar chord library
  - ChordFind.com
  - Guitar Chord Generator websites
- **Create Your Own**: 
  - Use apps like Chord Designer
  - Draw them digitally
  - Take photos of hand positions

## How It Works:
When a user taps any chord in the songs list, the app will:
1. Look for a matching image file in this folder
2. Show the chord diagram in a popup dialog
3. Display a placeholder with the chord name if no image is found

## Testing:
Add a few common chord diagrams (like `c.png`, `g.png`, `am.png`) to test the functionality with your existing songs.
