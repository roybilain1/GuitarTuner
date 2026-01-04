🎸 Guitar Tuner App — Full-Stack Flutter Web Application

A modern full-stack Flutter web application designed for guitar learners and music enthusiasts.
The Guitar Tuner App combines a curated song library, interactive chord diagrams, audio playback, cloud-synced favorites, and a built-in guitar tuner — all accessible from any modern web browser.

Built with Flutter (Web) on the frontend and Node.js + MySQL on the backend, this project demonstrates real-world full-stack development, clean architecture, API integration, and cloud deployment.

🚀 Features
🎵 Learning & Practice

Curated song library featuring 10 famous international and Arabic guitar songs

Interactive chord diagrams covering 17 commonly used chords

Built-in audio player with play, pause, and seek controls

Clear chord progressions displayed alongside each song

⭐ Personalization

Mark songs as favorites

Favorites stored and synced in the cloud database

Real-time updates across sessions

🎚️ Guitar Tuner

Simple and interactive guitar tuning interface

Designed for beginners and casual practice

🌐 Web-Based & Responsive

Runs entirely in the browser

Fully responsive UI for desktop and tablet

No installation required for end users

🏗️ System Architecture
Flutter Web (Dart)
        │
        │ REST API (HTTP)
        ▼
Node.js + Express API
        │
        ▼
MySQL Database
(Railway Cloud)

🛠️ Technology Stack
Frontend

Flutter 3.27.1

Dart 3.6.1

audioplayers – Audio playback

http – REST API communication

Backend

Node.js

Express.js

MySQL 8.0

CORS for cross-origin access

Infrastructure & Deployment

Railway — Backend & Database hosting

GitHub — Version control

GitHub Pages / Web Hosting (Frontend)

🎬 Live Demo

Production Backend API
👉 https://guitartuner-production.up.railway.app

📁 Project Structure
guitartuner/
├── lib/            # Flutter source code
│   ├── main.dart
│   ├── home.dart
│   ├── tuning.dart
│   ├── songs.dart
│   └── favorites.dart
│
├── backend/        # Node.js backend
│   ├── server.js
│   ├── railway-init.sql
│   ├── init-db-via-api.js
│   └── package.json
│
├── assets/
│   ├── chords/     # 17 chord diagrams
│   ├── songs/      # Audio files
│   └── images/
│
└── README.md

📡 API Overview
Base URL
https://guitartuner-production.up.railway.app

Key Endpoints

Songs

GET /songs — Fetch all songs

GET /songs/:id — Fetch song by ID

PATCH /songs/:id/favorite — Toggle favorite status

Chords

GET /chords — Fetch all chords

GET /chords/:name — Fetch chord by name

🗄️ Database Design
Songs Table
id | title | artist | chords | audio_path | is_favorite

Chords Table
id | name | image_path | description | difficulty_level


Designed for scalability and easy extension.

🎵 Included Content
Song Library (10 Songs)

Hotel California – Eagles

Stairway to Heaven – Led Zeppelin

Sweet Child O’ Mine – Guns N’ Roses

Nothing Else Matters – Metallica

Wish You Were Here – Pink Floyd

Creep – Radiohead

Amara – Fayrouz

Shayef – Adonis

Estesna’i – Adonis

Law Baddak Yani – Adonis

Chords

Major, Minor, and 7th chords

Beginner-friendly diagrams with clear visuals

🚢 Deployment

Backend deployed on Railway

MySQL managed via Railway cloud services

Environment variables handled securely

Automatic redeployment on GitHub push

🎯 Project Highlights

Full-stack architecture (Flutter + Node.js + MySQL)

Clean separation of frontend and backend

Real-time cloud data synchronization

Practical use of REST APIs

Production deployment on Railway

🌟 Summary

The Guitar Tuner App is a complete, production-style full-stack project that blends music education with modern web technologies. It demonstrates strong skills in Flutter web development, backend API design, database management, and cloud deployment — making it an excellent portfolio project for mobile and web development roles.

👨‍💻 Author

Roy Bilain
https://github.com/roybilain1/GuitarTuner

<img width="497" height="881" alt="home" src="https://github.com/user-attachments/assets/c7131f34-a0a4-483e-b3d4-201d47814778" />

<img width="500" height="894" alt="tuner" src="https://github.com/user-attachments/assets/cc2ec45c-b201-41ab-9e49-dd5b621dd956" />

<img width="497" height="900" alt="songs" src="https://github.com/user-attachments/assets/4a03a712-a677-4a64-81c4-9285b43583f9" />

<img width="499" height="903" alt="chordsDiagram" src="https://github.com/user-attachments/assets/47699ef5-21f6-41b3-b979-55bee10dd304" />

<img width="498" height="891" alt="favorites" src="https://github.com/user-attachments/assets/8713c241-3268-46fe-b324-2eb72bdd1f9d" />


