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


Clone the project

git clone https://github.com/roybilain1/GuitarTuner.git


<img width="1290" height="2796" alt="simulator_screenshot_7DB2DD50-C20D-424A-B1CC-7B631B1A206F" src="https://github.com/user-attachments/assets/2031c69c-6e97-42e8-a3cc-b389fb76272c" />
<img width="440" height="912" alt="Screenshot 2025-11-24 at 11 35 04 PM" src="https://github.com/user-attachments/assets/12f5417e-d8dd-46cb-9bfe-523af42fde24" />






