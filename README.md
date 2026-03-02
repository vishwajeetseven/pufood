<p align="center">
  <img src="web/logo.png" alt="Net Bar" width="220" height="120">
</p>

> **ARCHIVED PROJECT**
> 
> This project has been archived on March 2, 2026. The codebase is available for reference and forking, but contributions are no longer being accepted. The application may continue to work as-is, but no further updates or maintenance will be provided.
>
> **GitHub Repository:** https://github.com/iad1tya/pufood

A comprehensive food discovery platform for Parul University students. PUFood helps students explore dining options across campus, compare prices, find nutritional information, and make informed food choices.

## Features

- **Multi-Platform Support**
  - Web Application (Progressive Web App)
  - Android App (Flutter)
  - iOS Support
  - Lite Version for low-bandwidth users

- **Smart Search & Filters**
  - Real-time search across 100+ food items
  - Filter by dietary preferences (Veg/Non-Veg)
  - Price range filtering
  - High protein options
  - Sort by price (Low to High / High to Low)

- **Nutrition Information**
  - Detailed macronutrients (Protein, Carbs, Fat)
  - Calorie information
  - Dietary type indicators

- **Price Comparison**
  - Compare up to 4 items simultaneously
  - Find best deals across campus outlets
  - Real-time menu updates

- **Campus Integration**
  - 50+ food outlets mapped
  - Location-based outlet information
  - PDF menus for each outlet
  - Direct links to outlet pages

## Quick Start

### Web Application

1. Clone the repository:
```bash
git clone https://github.com/iad1tya/pufood.git
cd pufood
```

2. Serve the web files:
```bash
cd web
python -m http.server 8000
```

3. Open `http://localhost:8000` in your browser

### Flutter Mobile App

1. Navigate to the Flutter app directory:
```bash
cd app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

For Android build:
```bash
flutter build apk --release
```

For iOS build:
```bash
flutter build ios --release
```
Project Structure

```
pufood/
├── README.md                   # Project documentation
├── CONTRIBUTING.md             # Contribution guidelines
├── CODE_OF_CONDUCT.md         # Community standards
├── LICENSE                     # MIT License
├── SECURITY.md                 # Security policy
├── CHANGELOG.md                # Version history
├── API_DOCUMENTATION.md        # API reference
├── DEPLOYMENT.md               # Deployment guide
├── DOCS_INDEX.md               # Documentation index
│
├── web/                        # Web application
│   ├── index.html             # Main web application
│   ├── config.js              # Configuration file
│   ├── data.json              # Food items database
│   ├── outletMenus.json       # Outlet information
│   ├── manifest.json          # PWA manifest
│   ├── Menu/                  # PDF menus
│   ├── Lite-PUFood-main/      # Lightweight version
│   └── [HTML pages]           # Additional pages
│
└── app/                       # Flutter mobile app
    ├── lib/
    │   ├── main.dart
    │   ├── models/            # Data models
    │   ├── screens/           # UI screens
    │   ├── services/          # API services
    ├── widgets/           # Reusable components
    │   └── theme/             # App theming
    ├── android/               # Android platform
    ├── ios/                   # iOS platform
    └── assets/                # Apprm files
    └── assets/            # Images and resources
```

## Technologies Used

### Web Application
- HTML5, CSS3, JavaScript (ES6+)
- Progressive Web App (PWA)
- Service Workers for offline support
- Responsive design with mobile-first approach
- Google Analytics integration
- Firebase for backend services

### Mobile Application
- **Framework:** Flutter 3.7.2+
- **State Management:** StatefulWidget
- **HTTP Client:** http package
- **UI Components:**
  -ncfusion PDF Viewer
  - FL Chart for data visualization
  - Flutter Animate for animations
- **Firebase:** Analytics and Core
- **Other Packages:**
  - package_info_plus
  - flutter_launcher_icons

## Data Structure

### Food Item Format
```json
{
  "name": "Item Name",
  "price": 50,
  "protein": 10,
  "carbs": 30,
  "fat": 5,
  "outlet": "Outlet Name"
}
```

### Outlet Menu Format
```json
{
  "name": "Outlet Name",
  "link": "https://pufood.xyz/Menu/outlet-menu.pdf"
}
```

## Configuration

### API Configuration (config.js)
```javascript
export const config = {
    OPENROUTER_API_KEY: 'your-api-key',
    API_URL: 'https://openrouter.ai/api/v1/chat/completions',
    DEFAULT_MODEL: 'deepseek/deepseek-r1:free',
    SYSTEM_PROMPT: 'Your system prompt'
};
```

### Firebase Setup
1. Create a Firebase project
2. Add your `google-services.json` to `app/android/app/`
3. Add your `GoogleService-Info.plist` to `app/ios/Runner/`

## Mobile App Features

- **Splash Screen:** Animated app launch
- **Home Screen:** Browse all food items with search and filters
- **Outlet Screen:** View outlet-wise food categorization
- **Comparison Screen:** Side-by-side comparison of food items
- **Settings Screen:** App preferences and about information
- **Auto-Update:** Built-in update checker

## Deployment

### Web Deployment
Deploy to any static hosting service:
- GitHub Pages
- Netlify
- Vercel
- Firebase Hosting

### Mobile App Deployment
- **Android:** Google Play Store
- **iOS:** Apple App Store

## Contributing

> **Note:** This project was archived on March 2, 2026. Contributions are no longer being accepted.

Historically, I welcomed contributions from the community. Here's how you could have helped:

1. **Add New Outlets**
   - Submit outlet information via the web form
   - Provide menu PDFs
   - Update pricing information

2. **Report Issues**
   - Use GitHub Issues
   - Provide detailed descriptions
   - Include screenshots if applicable

3. **Code Contributions**
   - Fork the repository
   - Create a feature branch
   - Submit a pull request

### Contribution Guidelines
- Follow existing code style
- Write clear commit messages
- Test your changes thoroughly
- Update documentation as needed

## Acknowledgments

- Parul University students for feedback
- Contributors who helped add and verify food data
- All campus food outlet owners

## Statistics

- **50+ Food Outlets** covered
- **1000+ Food Items** catalogued
- **24,000+ Data Entries**
- **Active Users:** Growing daily

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Made for Parul University Students
