# Railway Deployment Guide

Follow these steps to deploy your Guitar Tuner backend to Railway.

## Prerequisites
- GitHub account
- Railway account (sign up at https://railway.app)
- Your code pushed to GitHub (guitartuner folder with backend inside)

## Important: Project Structure
Your backend is located at `guitartuner/backend/` within your git repository.
Railway will need to know this path during deployment.

## Step-by-Step Deployment

### 1. Ensure Your Code is on GitHub

```bash
cd /Users/apple/LIU/Mobile/project1/guitartuner
git add .
git commit -m "Prepare backend for Railway deployment"
git push
```

### 2. Sign Up for Railway

1. Go to https://railway.app
2. Sign up with your GitHub account
3. Authorize Railway to access your repositories

### 3. Create New Project on Railway

1. Go to https://railway.app and log in with GitHub
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your guitartuner repository
5. Railway will detect it's a Node.js project

### 4. Configure Root Directory (IMPORTANT!)

Since your backend is in a subdirectory, you need to tell Railway:

1. In your Railway project, click on the service
2. Go to "Settings" tab
3. Find "Root Directory" setting
4. Set it to: `backend`
5. Save changes

### 5. Add MySQL Database

1. In your Railway project dashboard, click "+ New"
2. Select "Database" → "Add MySQL"
3. Railway will create a MySQL instance
4. Copy the connection details (host, user, password, database name)

### 5. Configure Environment Variables

In your Railway project:

1. Click on your Node.js service
2. Go to "Variables" tab
3. Add these variables:

```
DB_HOST=<from-mysql-service>
DB_USER=root
DB_PASSWORD=<from-mysql-service>
DB_NAME=railway
PORT=5001
```

**Tip:** Railway provides these variables automatically when you add MySQL:
- `MYSQL_HOST`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `MYSQL_DATABASE`

You can reference them like: `${{MySQL.MYSQL_HOST}}`

### 6. Initialize the Database

1. Click on your MySQL service in Railway
2. Click "Data" tab
3. Click "Query"
4. Copy and paste the contents of `init-db.sql`
5. Click "Run Query"

Or connect via MySQL client:
```bash
mysql -h <MYSQL_HOST> -u root -p<MYSQL_PASSWORD> railway < init-db.sql
```

### 7. Deploy!

1. Railway will automatically deploy when you push to GitHub
2. Your API will be available at: `https://your-project.up.railway.app`
3. Test your API: `https://your-project.up.railway.app/songs`

### 8. Get Your API URL

1. Go to your Node.js service in Railway
2. Click "Settings"
3. Under "Networking", you'll see your public domain
4. Copy this URL - you'll need it for your Flutter app

Example: `https://guitartuner-backend-production.up.railway.app`

## Verify Deployment

Test your endpoints:

```bash
# Health check
curl https://your-project.up.railway.app/

# Get all songs
curl https://your-project.up.railway.app/songs

# Get all chords
curl https://your-project.up.railway.app/chords
```

## Update Flutter App

Once deployed, update your Flutter app API URLs:

In `lib/songs.dart` and `lib/favorites.dart`, change:
```dart
// FROM:
final String apiUrl = "http://localhost:5001/songs";

// TO:
final String apiUrl = "https://your-project.up.railway.app/songs";
```

## Automatic Deployments

Railway will automatically deploy when you push to your main branch:

```bash
git add .
git commit -m "Update backend"
git push origin main
```

## Monitoring

- View logs in Railway dashboard under "Deployments" → "View Logs"
- Monitor database usage under MySQL service
- Check API health at: `https://your-project.up.railway.app/`

## Troubleshooting

### Database Connection Issues
- Verify environment variables are set correctly
- Check that MySQL service is running
- Ensure database is initialized with tables

### Deployment Fails
- Check logs in Railway dashboard
- Verify `package.json` has correct start script
- Ensure all dependencies are in `package.json`

### CORS Issues
- Verify CORS is enabled in `server.js`
- Update CORS config if needed for specific origins

## Railway Free Tier Limits
- 500 hours/month execution time
- $5 credit per month
- 1GB memory
- 1GB disk space

Your app should stay within these limits easily!

## Next Steps

1. ✅ Deploy backend to Railway
2. ✅ Initialize database
3. ✅ Test API endpoints
4. Update Flutter app with new API URL
5. Test Flutter app with production API
6. Deploy Flutter app (if needed)

## Support

- Railway Docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway
- Project Issues: [Your GitHub Repo]/issues
