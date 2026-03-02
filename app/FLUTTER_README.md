# PUFood Flutter App Documentation

> **ARCHIVED PROJECT**
> 
> This project has been archived on March 2, 2026. No further updates or support will be provided.
>
> **GitHub Repository:** https://github.com/iad1tya/pufood

## Overview

The PUFood mobile application is built with Flutter, providing a native experience for both Android and iOS users. The app allows students to browse food options, compare prices, and find nutritional information for campus food outlets.

## Architecture

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── food_item.dart       # Food item model
│   └── outlet.dart          # Outlet model
├── screens/                  # UI screens
│   ├── home_screen.dart     # Main food browsing screen
│   ├── outlet_screen.dart   # Outlet-wise view
│   ├── comparison_screen.dart # Food comparison
│   ├── settings_screen.dart  # App settings
│   └── splash_screen.dart   # Launch screen
├── services/                 # Business logic
│   ├── api_service.dart     # API calls
│   ├── analytics_service.dart # Firebase analytics
│   └── update_service.dart  # App update checks
├── widgets/                  # Reusable components
│   ├── food_item_card.dart  # Food item display
│   ├── fluid_nav_bar.dart   # Navigation bar
│   ├── filter_bottom_sheet.dart # Filter UI
│   ├── food_grid.dart       # Grid layout
│   └── shimmer_loading.dart # Loading animation
└── theme/
    └── app_theme.dart       # App theming
```

## Core Features

### 1. Food Browsing (HomeScreen)

**Features:**
- Grid/List view of all food items
- Real-time search
- Multiple filters (price, diet, protein)
- Sort options
- Item selection for comparison

**Key Components:**
```dart
class HomeScreen extends StatefulWidget {
  // Main screen for browsing food items
  // Implements search, filter, and comparison
}
```

**State Management:**
- Uses StatefulWidget
- Local state for filters and search
- API service for data fetching

### 2. Outlet View (OutletScreen)

**Features:**
- Outlet-wise food categorization
- Search within outlets
- PDF menu links
- Outlet location information

**Implementation:**
```dart
class OutletScreen extends StatefulWidget {
  // Groups food items by outlet
  // Provides outlet-specific filtering
}
```

### 3. Food Comparison (ComparisonScreen)

**Features:**
- Side-by-side comparison
- Up to 4 items
- Nutritional breakdown
- Price comparison charts

**Data Visualization:**
- Uses FL Chart for graphs
- Compare macronutrients
- Visual price indicators

### 4. Settings (SettingsScreen)

**Features:**
- App version display
- Update checker
- Contact information
- About section

## Data Models

### FoodItem Model

```dart
class FoodItem {
  final String name;
  final double price;
  final double protein;
  final double carbs;
  final double fat;
  final String outlet;

  FoodItem({
    required this.name,
    required this.price,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.outlet,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      outlet: json['outlet'] as String,
    );
  }
}
```

### Outlet Model

```dart
class Outlet {
  final String name;
  final String link;

  Outlet({
    required this.name,
    required this.link,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) {
    return Outlet(
      name: json['name'] as String,
      link: json['link'] as String,
    );
  }
}
```

## Services

### API Service

Handles all network requests with retry logic and error handling.

**Methods:**
- `getFoodItems()` - Fetch all food items
- `getOutlets()` - Fetch outlet information
- Retry mechanism with exponential backoff
- Comprehensive error handling

**Configuration:**
```dart
class ApiService {
  static const String baseUrl = 'https://www.pufood.xyz';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
}
```

### Update Service

Checks for app updates from the server.

**Features:**
- Version comparison
- APK download links
- Release notes display
- Automatic update notifications

### Analytics Service

Firebase Analytics integration for user behavior tracking.

**Events Tracked:**
- Screen views
- Search queries
- Filter usage
- Comparison actions
- Outlet views

## UI Components

### Custom Widgets

#### FoodItemCard
```dart
Widget _buildFoodItemCard(FoodItem item) {
  return Card(
    child: Column(
      children: [
        Text(item.name),
        Text('₹${item.price}'),
        Row(
          children: [
            NutritionChip(label: 'Protein', value: item.protein),
            NutritionChip(label: 'Carbs', value: item.carbs),
            NutritionChip(label: 'Fat', value: item.fat),
          ],
        ),
      ],
    ),
  );
}
```

#### FluidNavBar
Custom bottom navigation with fluid animations.

#### ShimmerLoading
Loading skeleton screens for better UX.

## Theme

### Color Scheme
```dart
class AppTheme {
  static const Color primaryColor = Color(0xFFFF0000);
  static const Color backgroundColor = Color(0xFFF5F5F7);
  static const Color cardColor = Colors.white;
}
```

### Typography
- Poppins for headings
- Roboto for body text

## Building and Deployment

### Development Build

```bash
flutter run
```

### Android Release Build

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS Release Build

```bash
flutter build ios --release
```

### Build Optimization

- Enable R8/ProGuard for Android
- Code shrinking enabled
- Image optimization
- Lazy loading of data

## Testing

### Run Tests

```bash
flutter test
```

### Widget Tests

Located in `test/widget_test.dart`

### Integration Tests

To be added in future updates.

## Firebase Configuration

### Android Setup

1. Add `google-services.json` to `android/app/`
2. Configure Firebase in Android build files

### iOS Setup

1. Add `GoogleService-Info.plist` to `ios/Runner/`
2. Configure Firebase in iOS project

## Performance Optimization

### Implemented Optimizations

1. **Lazy Loading**
   - Load food items in batches
   - Infinite scroll implementation

2. **Caching**
   - Local storage of API responses
   - Image caching

3. **Efficient Rendering**
   - Use of `const` constructors
   - ListView.builder for large lists
   - Proper disposal of controllers

4. **Network Optimization**
   - Retry logic with exponential backoff
   - Request timeout handling
   - Compression support

## Common Issues and Solutions

### Issue: App doesn't fetch data
**Solution:** Check internet connection and API endpoint availability

### Issue: Build fails on iOS
**Solution:** Run `pod install` in ios/ directory

### Issue: Firebase not working
**Solution:** Verify google-services.json and GoogleService-Info.plist are properly configured

## Future Enhancements

### Planned Features
1. Offline mode with local database
2. User authentication
3. Favorites and history
4. Push notifications for deals
5. In-app ordering integration
6. Social sharing
7. Reviews and ratings

### Technical Improvements
1. State management with Provider/Riverpod
2. Unit test coverage increase
3. CI/CD pipeline
4. Crashlytics integration
5. Performance monitoring

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Material Design Guidelines](https://material.io/design)

---

End of Flutter App Documentation
