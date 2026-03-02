# Deployment Guide

> **PROJECT ARCHIVED**
> 
> This project was archived on March 2, 2026. This deployment guide is maintained for reference purposes only. No support will be provided for deployment issues.
>
> **GitHub Repository:** https://github.com/iad1tya/pufood

This guide covers deploying both the web application and the Flutter mobile app.

## Table of Contents

1. [Web Application Deployment](#web-application-deployment)
2. [Flutter Mobile App Deployment](#flutter-mobile-app-deployment)
3. [Database and Backend](#database-and-backend)
4. [CI/CD Setup](#cicd-setup)

## Web Application Deployment

### Prerequisites

- Web server (Apache, Nginx, or any static file server)
- Domain name (optional but recommended)
- SSL certificate (for HTTPS)

### Deployment Options

#### Option 1: GitHub Pages

1. **Push code to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/username/pufood.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to repository Settings
   - Navigate to Pages section
   - Select source branch (main)
   - Set folder to /web (if available) or / (root) and manually configure paths
   - Save and wait for deployment

3. **Custom Domain (Optional)**
   - Add CNAME file to web/ folder with your domain
   - Configure DNS settings

#### Option 2: Netlify

1. **Install Netlify CLI**
   ```bash
   npm install -g netlify-cli
   ```

2. **Deploy**
   ```bash
   cd pufood
   netlify deploy --prod --dir=web
   ```

3. **Configuration**
   
   Create `netlify.toml`:
   ```toml
   [build]
     publish = "web"
   
   [[redirects]]
     from = "/*"
     to = "/index.html"
     status = 200
   ```

#### Option 3: Vercel

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Deploy**
   ```bash
   cd pufood
   vercel --prod
   ```

3. **Configuration**
   
   Create `vercel.json`:
   ```json
   {
     "buildCommand": "echo 'No build needed'",
     "outputDirectory": "web",
     "routes": [
       {
         "src": "/(.*)",
         "dest": "/$1"
       }
     ]
   }
   ```

#### Option 4: Firebase Hosting

1. **Install Firebase CLI**
   ```bash
   npm install -g firebase-tools
   ```

2. **Initialize Firebase**
   ```bash
   firebase login
   firebase init hosting
   ```

3. **Configure firebase.json**
   ```json
   {
     "hosting": {
       "public": "web",
       "ignore": [
         "firebase.json",
         "**/.*",
         "**/node_modules/**"
       ],
       "rewrites": [
         {
           "source": "**",
           "destination": "/index.html"
         }
       ]
     }
   }
   ```

4. **Deploy**
   ```bash
   firebase deploy --only hosting
   ```

### Environment Configuration

1. **Update API endpoints** in `web/config.js`
2. **Configure Google Analytics** tracking ID
3. **Update Firebase configuration**
4. **Set up service worker** for PWA

### Post-Deployment Checklist

- [ ] Test all pages load correctly
- [ ] Verify API endpoints are accessible
- [ ] Check mobile responsiveness
- [ ] Test PWA installation
- [ ] Verify offline mode works
- [ ] Test on multiple browsers
- [ ] Check SSL certificate
- [ ] Verify search functionality
- [ ] Test filter and sort features
- [ ] Check PDF menu links

## Flutter Mobile App Deployment

### Android Deployment

#### Prerequisites

- Android Studio
- Flutter SDK
- Java Development Kit (JDK)
- Google Play Developer account ($25 one-time fee)

#### Step 1: Prepare App for Release

1. **Update app version** in `pubspec.yaml`:
   ```yaml
   version: 1.0.1+1  # version_name+build_number
   ```

2. **Create keystore** (first time only):
   ```bash
   keytool -genkey -v -keystore ~/pufood-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pufood
   ```

3. **Create key.properties** in `android/`:
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=pufood
   storeFile=/path/to/pufood-key.jks
   ```

4. **Update build.gradle** (`android/app/build.gradle`):
   ```gradle
   def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }
   
   android {
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

#### Step 2: Build Release APK

```bash
cd app
flutter clean
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Step 3: Build App Bundle (Recommended for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

#### Step 4: Google Play Store Submission

1. **Create app listing** in Google Play Console
2. **Upload app bundle** (.aab file)
3. **Complete store listing**:
   - App title: "PUFood - Parul University Food Guide"
   - Short description
   - Full description
   - Screenshots (phone, tablet, optional)
   - Feature graphic (1024x500)
   - App icon (512x512)

4. **Set content rating**
5. **Add privacy policy URL**
6. **Submit for review**

### iOS Deployment

#### Prerequisites

- Mac computer
- Xcode
- Apple Developer account ($99/year)
- CocoaPods

#### Step 1: Prepare for Release

1. **Update version** in `pubspec.yaml`

2. **Install dependencies**:
   ```bash
   cd iOS
   pod install
   cd ..
   ```

3. **Open in Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

4. **Configure signing**:
   - Select Runner target
   - General tab
   - Signing & Capabilities
   - Select your team
   - Configure bundle identifier

#### Step 2: Build Release

```bash
flutter build ios --release
```

#### Step 3: Create Archive

1. In Xcode: Product → Archive
2. Wait for archive to complete
3. Click "Distribute App"
4. Choose "App Store Connect"
5. Upload to App Store

#### Step 4: App Store Submission

1. **Go to App Store Connect**
2. **Create new app**
3. **Fill in metadata**:
   - App name
   - Description
   - Keywords
   - Screenshots
   - App icon

4. **Submit for review**

### Alternative Distribution

#### Direct APK Distribution

Host the APK on your website:

```html
<a href="https://pufood.xyz/downloads/pufood-v1.0.1.apk" 
   download>Download PUFood APK</a>
```

Update `app.json` for auto-updates:
```json
{
  "version": "1.0.1",
  "apk_url": "https://pufood.xyz/downloads/pufood-v1.0.1.apk",
  "release_notes": "Latest features and improvements"
}
```

## Database and Backend

### JSON Data Updates

The app uses static JSON files. To update:

1. **Edit data.json** with new food items
2. **Edit outletMenus.json** for menu changes
3. **Deploy updated files** to server
4. **Clear CDN cache** if applicable

### Menu PDF Management

1. Upload PDFs to `Menu/` directory
2. Update `outletMenus.json` with new links
3. Ensure filenames match exactly

## CI/CD Setup

### GitHub Actions for Web

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Web App

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Deploy to Firebase
        uses: w9jds/firebase-action@master
        with:
          args: deploy --only hosting
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

### GitHub Actions for Flutter

Create `.github/workflows/flutter-build.yml`:

```yaml
name: Flutter Build

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.7.2'
      
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
      
      - uses: actions/upload-artifact@v2
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

## Monitoring and Analytics

### Google Analytics Setup

1. Add tracking ID to HTML files
2. Verify data collection
3. Set up goals and conversions

### Firebase Analytics (Mobile)

1. Configure google-services.json
2. Enable Analytics in Firebase Console
3. Monitor user behavior

## Security Considerations

1. **Use HTTPS** for all deployments
2. **Sanitize user inputs**
3. **Implement rate limiting**
4. **Regular security audits**
5. **Keep dependencies updated**
6. **Secure API keys** (use environment variables)

## Rollback Procedures

### Web Rollback

```bash
# Git
git revert <commit-hash>
git push origin main

# Firebase
firebase hosting:clone source:target
```

### Mobile Rollback

- Halt staged rollout in Play Console
- Upload previous version
- Contact Apple for emergency updates

## Performance Optimization

### Web
- Enable gzip compression
- Minimize CSS/JavaScript
- Optimize images
- Use CDN for assets
- Enable browser caching

### Mobile
- Enable R8/ProGuard
- Optimize image assets
- Use release mode builds
- Profile app performance

---

End of Deployment Guide
