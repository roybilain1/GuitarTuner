🎸 Guitar Tuning Helper App

A professional and visually themed guitar tuning app, inspired by the Fender Stratocaster guitar. Designed to help users tune their guitar strings using reference sounds, interactive buttons aligned with the headstock image, and additional information about each string.

Built with Flutter, featuring a bordo and white color scheme to match your personal guitar aesthetic.

📱 Features
✔️ Core Functionality

🎨 Custom AppBar — bordo color, centered title, increased height.

🖼 Fixed-size headstock image (e.g., 500×600 px), centered with bordo padding.

🔘 Six tuning buttons (E, A, D, G, B, e) precisely positioned over tuning keys.

🔊 Reference sound playback using audioplayers.

⏹ Stop button shown while sound is playing.

ℹ️ Info button appears after playback to show:

String frequency (Hz)

Motivational quote 💪

📝 Current string display at bottom center of screen.

🛠️ Tech & Packages
Tool / Package	Purpose
Flutter	UI development (cross-platform)
audioplayers	Audio playback
google_fonts (optional)	Custom font styling
📂 Project Structure
lib/
├── main.dart        # App entry point
└── home.dart        # Main UI screen, buttons, image, sound logic

assets/
├── images/
│   └── headstock.png            # Background image
└── sounds/
    ├── LowE.mp3
    ├── A.mp3
    ├── D.mp3
    ├── G.mp3
    ├── B.mp3
    └── HighE.mp3               # Reference sound files

🔄 State Management
Variable	Purpose
selectedString	Tracks the string being played
isPlaying	Indicates if a sound is currently playing
🚀 User Flow

Launch the app → Stylish AppBar + headstock image.

Tap a string button → Plays the correct reference sound.

String name appears at the bottom.

Stop button visible → tap to stop sound.

Info button → shows frequency + motivational quote.

Choose another string and repeat 🎵

🎨 Design Highlights

Fixed-size image ensures accurate button placement on all screens.

Bordo & white color theme for a personalized and professional feel.

Sleek minimal UI — no clutter, simple navigation, clean feedback.

🔧 Setup Instructions

Clone the project

git clone <repository-url>
