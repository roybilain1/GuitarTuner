# 🚀 Quick Start - Deploy to Railway

## ✅ Your Backend is Ready!

All files have been prepared for Railway deployment.

## Next Steps:

### 1️⃣ Push to GitHub (if not already)

```bash
cd /Users/apple/LIU/Mobile/project1/backend

# Initialize git (if not done)
git init
git add .
git commit -m "Prepare backend for Railway deployment"

# Create GitHub repo and push
# (Create new repo at github.com/new)
git remote add origin https://github.com/YOUR_USERNAME/guitartuner-backend.git
git branch -M main
git push -u origin main
```

### 2️⃣ Deploy to Railway

1. **Go to** https://railway.app
2. **Sign in** with GitHub
3. **Click** "New Project"
4. **Select** "Deploy from GitHub repo"
5. **Choose** your guitartuner-backend repository
6. Railway will auto-detect Node.js and deploy!

### 3️⃣ Add MySQL Database

1. In Railway dashboard, click **"+ New"**
2. Select **"Database"** → **"Add MySQL"**
3. MySQL will be provisioned automatically

### 4️⃣ Connect Database to Backend

1. Click on your **backend service**
2. Go to **"Variables"** tab
3. Click **"+ New Variable"**
4. Add **Reference** variables:

```
DB_HOST = ${{MySQL.MYSQLHOST}}
DB_USER = ${{MySQL.MYSQLUSER}}
DB_PASSWORD = ${{MySQL.MYSQLPASSWORD}}
DB_NAME = ${{MySQL.MYSQLDATABASE}}
```

5. Click **"Deploy"**

### 5️⃣ Initialize Database

1. Click on **MySQL service**
2. Go to **"Data"** tab
3. Copy content from `init-db.sql`
4. Paste and **"Run Query"**

### 6️⃣ Get Your API URL

1. Click on your **backend service**
2. Go to **"Settings"** → **"Networking"**
3. Copy the **Public Domain** (e.g., `https://guitartuner-backend-production.up.railway.app`)

### 7️⃣ Test Your API

```bash
curl https://YOUR-RAILWAY-URL.up.railway.app/
curl https://YOUR-RAILWAY-URL.up.railway.app/songs
```

### 8️⃣ Update Flutter App

Replace API URLs in Flutter:

**In `lib/songs.dart` and `lib/favorites.dart`:**

```dart
// Change from:
final String apiUrl = "http://localhost:5001/songs";
final String chordsApiUrl = "http://localhost:5001/chords";

// To:
final String apiUrl = "https://YOUR-RAILWAY-URL.up.railway.app/songs";
final String chordsApiUrl = "https://YOUR-RAILWAY-URL.up.railway.app/chords";
```

## 🎉 You're Done!

Your backend is now live and accessible from anywhere!

## 📚 Additional Resources

- Full deployment guide: `DEPLOYMENT.md`
- Railway docs: https://docs.railway.app
- Database schema: `init-db.sql`

## 💰 Cost

Railway free tier includes:
- 500 hours/month
- $5 credit/month
- Perfect for development and small projects!

## 🆘 Need Help?

Check `DEPLOYMENT.md` for troubleshooting and detailed instructions.
