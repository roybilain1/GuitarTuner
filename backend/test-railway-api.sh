#!/bin/bash

# Test Railway Backend API
# Usage: ./test-railway-api.sh YOUR_RAILWAY_URL

if [ -z "$1" ]; then
  echo "❌ Please provide your Railway backend URL"
  echo ""
  echo "Usage: ./test-railway-api.sh https://your-app.up.railway.app"
  echo ""
  echo "To find your URL:"
  echo "1. Go to Railway dashboard"
  echo "2. Click on your backend service (GuitarTuner)"
  echo "3. Look for the public URL at the top or in Settings > Networking"
  exit 1
fi

RAILWAY_URL=$1

echo "🧪 Testing Railway Backend API..."
echo "URL: $RAILWAY_URL"
echo ""

echo "1️⃣ Testing health check..."
curl -s "$RAILWAY_URL/" | head -20
echo ""
echo ""

echo "2️⃣ Testing /songs endpoint..."
curl -s "$RAILWAY_URL/songs" | head -50
echo ""
echo ""

echo "3️⃣ Testing /chords endpoint..."
curl -s "$RAILWAY_URL/chords" | head -50
echo ""
echo ""

echo "✅ Test complete!"
echo ""
echo "If you see data above, your backend is working! 🎉"
echo "Now update your Flutter app with this URL: $RAILWAY_URL"
