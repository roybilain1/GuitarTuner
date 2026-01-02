# Guitar Tuner Backend API

Backend API for the Guitar Tuner application built with Node.js, Express, and MySQL.

## Features
- Get all songs with chord information
- Get favorite songs
- Toggle favorite status
- Get chord diagrams and information
- RESTful API endpoints

## Tech Stack
- **Node.js** - Runtime environment
- **Express** - Web framework
- **MySQL** - Database
- **CORS** - Cross-origin resource sharing

## Environment Variables

Create a `.env` file with the following variables:

```
DB_HOST=your-mysql-host
DB_USER=root
DB_PASSWORD=your-password
DB_NAME=guitartuner
PORT=5001
```

## Installation

```bash
npm install
```

## Running Locally

```bash
npm start
```

The server will start on `http://localhost:5001`

## API Endpoints

- `GET /` - Health check
- `GET /songs` - Get all songs
- `GET /songs/:id` - Get song by ID
- `GET /songs/favorites` - Get favorite songs
- `PATCH /songs/:id/favorite` - Toggle favorite status
- `GET /chords` - Get all chords
- `GET /chords/:name` - Get chord by name

## Deployment

This app is ready for deployment on Railway, Render, or similar platforms.

### Railway Deployment

1. Push your code to GitHub
2. Sign up at [Railway](https://railway.app)
3. Create a new project
4. Add MySQL database service
5. Add this repository
6. Configure environment variables
7. Deploy!

## Database Schema

### Songs Table
- id (INT, PRIMARY KEY)
- title (VARCHAR)
- artist (VARCHAR)
- chords (TEXT) - comma-separated
- audio_path (VARCHAR)
- is_favorite (TINYINT)
- created_at (TIMESTAMP)

### Chords Table
- id (INT, PRIMARY KEY)
- name (VARCHAR)
- image_path (VARCHAR)
- description (TEXT)
- difficulty_level (VARCHAR)
- created_at (TIMESTAMP)
