# Guitar Tuner Backend - Railway Deployment Quick Guide

## 🚀 Quick Start

### 1. Push to GitHub (if not already)
```bash
cd /Users/apple/LIU/Mobile/project1/guitartuner
git add .
git commit -m "Prepare for Railway deployment"
git push
```

### 2. Deploy to Railway

1. **Sign up**: Go to https://railway.app and sign in with GitHub
2. **New Project**: Click "New Project" → "Deploy from GitHub repo"
3. **Select Repo**: Choose your guitartuner repository
4. **Set Root Directory**: 
   - Click on the service → Settings
   - Set "Root Directory" to `backend`
   - Save

5. **Add MySQL Database**:
   - In project, click "+ New" → Database → MySQL
   - Railway creates a MySQL instance automatically

6. **Configure Environment Variables**:
   - Click on your Node.js service → Variables
   - Add these (Railway auto-fills MySQL values):
   ```
   DB_HOST=${{MySQL.MYSQLHOST}}
   DB_USER=${{MySQL.MYSQLUSER}}
   DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}
   DB_NAME=${{MySQL.MYSQLDATABASE}}
   PORT=5001
   ```

7. **Initialize Database**:
   - Click MySQL service → Connect
   - Use the provided connection string or Railway's web terminal
   - Run the SQL from `railway-init.sql`

8. **Deploy**:
   - Railway auto-deploys on push to GitHub
   - Get your URL from Settings → Domains
   - Test: `https://your-app.up.railway.app/songs`

### 3. Update Flutter App

Update the API URLs in your Flutter files:

**In `lib/songs.dart` and `lib/favorites.dart`:**
```dart
final String apiUrl = "https://your-app.up.railway.app/songs";
final String chordsApiUrl = "https://your-app.up.railway.app/chords";
```

## 📋 Checklist

- [ ] Code pushed to GitHub
- [ ] Railway account created
- [ ] Project deployed
- [ ] Root directory set to `backend`
- [ ] MySQL database added
- [ ] Environment variables configured
- [ ] Database initialized with SQL
- [ ] API tested (GET /songs)
- [ ] Flutter app updated with new URL
- [ ] Flutter app redeployed

## 🔗 Important Links

- Railway Dashboard: https://railway.app/dashboard
- Documentation: https://docs.railway.app
- Your API Endpoints:
  - GET `/` - Health check
  - GET `/songs` - All songs
  - GET `/songs/:id` - Song by ID
  - GET `/songs/favorites` - Favorite songs
  - PATCH `/songs/:id/favorite` - Toggle favorite
  - GET `/chords` - All chords
  - GET `/chords/:name` - Chord by name

## 🆘 Troubleshooting

**Deployment fails?**
- Check that Root Directory is set to `backend`
- Verify package.json has `"start": "node server.js"`
- Check build logs in Railway dashboard

**Database connection fails?**
- Verify environment variables are set correctly
- Use Railway's provided MySQL variables
- Check MySQL service is running

**CORS issues?**
- Backend already has CORS enabled
- If issues persist, check Railway logs

## 📞 Need Help?

- Check Railway logs: Dashboard → Service → Deployments → View Logs
- Railway Discord: https://discord.gg/railway
- Full deployment guide: See DEPLOYMENT.md

---
✨ **Your backend is ready to deploy!**
