# API Documentation

> **PROJECT ARCHIVED**
> 
> This project was archived on March 2, 2026. This API documentation is preserved for reference. The API endpoints may or may not continue to function, and no support or updates will be provided.
>
> **GitHub Repository:** https://github.com/iad1tya/pufood

## Overview

PUFood uses a simple REST API architecture to serve food and outlet data. The API is primarily JSON-based and supports cross-origin requests.

## Base URL

```
https://www.pufood.xyz
```

## Endpoints

### 1. Get All Food Items

Retrieve the complete list of food items across all outlets.

**Endpoint:** `/data.json`

**Method:** `GET`

**Response:**
```json
[
  {
    "name": "Tea",
    "price": 10,
    "protein": 1,
    "carbs": 2,
    "fat": 0,
    "outlet": "PIT Canteen"
  },
  {
    "name": "Coffee",
    "price": 15,
    "protein": 1,
    "carbs": 3,
    "fat": 1,
    "outlet": "PIT Canteen"
  }
]
```

**Response Fields:**
- `name` (string): Name of the food item
- `price` (number): Price in INR (₹)
- `protein` (number): Protein content in grams
- `carbs` (number): Carbohydrate content in grams
- `fat` (number): Fat content in grams
- `outlet` (string): Name of the outlet serving this item

**Example Request:**
```javascript
fetch('https://www.pufood.xyz/data.json')
  .then(response => response.json())
  .then(data => console.log(data));
```

### 2. Get Outlet Menus

Retrieve information about all outlets and their menu PDFs.

**Endpoint:** `/outletMenus.json`

**Method:** `GET`

**Response:**
```json
[
  {
    "name": "BN IceCream",
    "link": "https://pufood.xyz/Menu/BN IceCream.pdf"
  },
  {
    "name": "Cafe Ape",
    "link": "https://pufood.xyz/Menu/Cafe Ape.pdf"
  }
]
```

**Response Fields:**
- `name` (string): Name of the outlet
- `link` (string): URL to the PDF menu

**Example Request:**
```javascript
fetch('https://www.pufood.xyz/outletMenus.json')
  .then(response => response.json())
  .then(menus => console.log(menus));
```

### 3. Get App Update Information

Check for available app updates (mobile app).

**Endpoint:** `/app/app.json`

**Method:** `GET`

**Response:**
```json
{
  "version": "1.0.1",
  "apk_url": "https://pufood.xyz/downloads/pufood-v1.0.1.apk",
  "release_notes": "Bug fixes and performance improvements"
}
```

**Response Fields:**
- `version` (string): Latest app version
- `apk_url` (string): Download URL for the APK
- `release_notes` (string): What's new in this version

## Error Handling

### HTTP Status Codes

- `200 OK`: Request successful
- `403 Forbidden`: Access denied (CORS or rate limiting)
- `404 Not Found`: Resource not found
- `500 Internal Server Error`: Server error
- `503 Service Unavailable`: Service temporarily down

### Error Response Format

```json
{
  "error": "Error message description",
  "code": "ERROR_CODE"
}
```

## Rate Limiting

Currently, there are no strict rate limits, but excessive requests may be throttled. Recommended practices:

- Implement client-side caching
- Cache responses for at least 5 minutes
- Use conditional requests (If-Modified-Since headers)
- Implement exponential backoff for retries

## CORS Policy

The API supports CORS for web applications. Allowed origins:
- `https://pufood.xyz`
- `https://www.pufood.xyz`
- `https://app.pufood.xyz`
- `http://localhost:*` (for development)

## Caching

### Recommended Cache Strategy

```javascript
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

async function fetchWithCache(url) {
  const cached = localStorage.getItem(url);
  
  if (cached) {
    const { data, timestamp } = JSON.parse(cached);
    if (Date.now() - timestamp < CACHE_DURATION) {
      return data;
    }
  }
  
  const response = await fetch(url);
  const data = await response.json();
  
  localStorage.setItem(url, JSON.stringify({
    data,
    timestamp: Date.now()
  }));
  
  return data;
}
```

## Request Examples

### JavaScript (Fetch API)

```javascript
async function getFoodItems() {
  try {
    const response = await fetch('https://www.pufood.xyz/data.json');
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const foodItems = await response.json();
    return foodItems;
    
  } catch (error) {
    console.error('Error fetching food items:', error);
    throw error;
  }
}
```

### Dart (Flutter)

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<FoodItem>> getFoodItems() async {
  final response = await http.get(
    Uri.parse('https://www.pufood.xyz/data.json')
  );
  
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => FoodItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load food items');
  }
}
```

### Python

```python
import requests

def get_food_items():
    response = requests.get('https://www.pufood.xyz/data.json')
    response.raise_for_status()
    return response.json()

food_items = get_food_items()
```

## Data Filtering

The API returns all data - filtering should be done client-side.

### Example: Filter by Price Range

```javascript
const foodItems = await getFoodItems();

const filteredItems = foodItems.filter(item => 
  item.price >= 20 && item.price <= 100
);
```

### Example: Filter by Outlet

```javascript
const cafeApeItems = foodItems.filter(item => 
  item.outlet === 'Cafe Ape'
);
```

### Example: Filter by Diet Type

```javascript
const nonVegKeywords = ['chicken', 'egg', 'mutton', 'fish'];

const isNonVeg = (name) => 
  nonVegKeywords.some(keyword => 
    name.toLowerCase().includes(keyword)
  );

const vegItems = foodItems.filter(item => !isNonVeg(item.name));
```

## Best Practices

### 1. Implement Retry Logic

```javascript
async function fetchWithRetry(url, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch(url);
      if (response.ok) return response.json();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await new Promise(resolve => 
        setTimeout(resolve, 1000 * Math.pow(2, i))
      );
    }
  }
}
```

### 2. Handle Offline Mode

```javascript
async function getFoodItemsOffline() {
  if (!navigator.onLine) {
    const cached = localStorage.getItem('foodData');
    if (cached) return JSON.parse(cached);
    throw new Error('No internet connection and no cached data');
  }
  
  const data = await fetchFoodItems();
  localStorage.setItem('foodData', JSON.stringify(data));
  return data;
}
```

### 3. Optimize Large Datasets

```javascript
function paginateData(data, page = 1, itemsPerPage = 50) {
  const start = (page - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  return data.slice(start, end);
}
```

## Webhooks

Currently, webhooks are not supported. Future versions may include:
- New item notifications
- Price change alerts
- Menu update notifications

## API Updates

This API documentation is subject to change. Subscribe to updates:
- GitHub repository watch
- Join community group
- Follow release notes

## Terms of Use

- API is free to use for non-commercial purposes
- Attribution appreciated
- No guarantee of uptime or data accuracy
- Data should not be scraped excessively
- Use reasonable caching strategies

## Changelog

### v1.0 (Current)
- Initial API release
- Food items endpoint
- Outlet menus endpoint
- App update endpoint
