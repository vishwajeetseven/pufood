import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';
import '../models/outlet.dart';

class ApiService {
  static const String baseUrl = 'https://www.pufood.xyz';
  static const String foodDataEndpoint = '/data.json';
  static const String outletMenusEndpoint = '/outletMenus.json';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  Map<String, String> get _defaultHeaders => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Origin': baseUrl,
    'Referer': '$baseUrl/',
    'User-Agent': 'Mozilla/5.0 (Dart) PUFood-App',
    'Cache-Control': 'no-cache',
    'Pragma': 'no-cache',
  };

  Future<http.Response> _makeRequest(
    String url, {
    Map<String, String>? additionalHeaders,
    String contentType = 'application/json',
  }) async {
    final headers = {
      ..._defaultHeaders,
      'Accept': contentType,
      'Content-Type': contentType,
      ...?additionalHeaders,
    };
    return http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: 15));
  }

  Future<http.Response> _retryRequest(
    Future<http.Response> Function() request,
  ) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final response = await request();
        if (response.statusCode == 200) {
          return response;
        }
        attempts++;
        if (attempts == maxRetries) {
          return response;
        }
        await Future.delayed(retryDelay * attempts);
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) rethrow;
        await Future.delayed(retryDelay * attempts);
      }
    }
    throw Exception('Failed after $maxRetries attempts');
  }

  Future<List<FoodItem>> getFoodItems() async {
    try {
      final response = await _retryRequest(
        () => _makeRequest('$baseUrl$foodDataEndpoint'),
      );

      if (response.statusCode == 200) {
        final String responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response received from server');
        }

        final dynamic decodedData = json.decode(responseBody);
        if (decodedData is! List) {
          throw Exception('Invalid data format: Expected a list of food items');
        }

        final List<FoodItem> items = [];
        for (final item in decodedData) {
          try {
            items.add(FoodItem.fromJson(item));
          } catch (e) {
            print('Error parsing food item: $e');
            continue;
          }
        }

        if (items.isEmpty) {
          throw Exception('No valid food items found in the response');
        }

        return items;
      } else if (response.statusCode == 403) {
        throw Exception('Access blocked. Please try again later.');
      } else {
        throw Exception(
          'Server error: Failed to load food items (Status: ${response.statusCode})',
        );
      }
    } on FormatException {
      throw Exception('Invalid data format received from server');
    } on TimeoutException {
      throw Exception(
        'Connection timeout. Please check your internet connection and try again',
      );
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Please check your internet connection');
      }
      throw Exception(
        'Network error: Unable to fetch food items. Please try again later',
      );
    }
  }

  Future<List<Outlet>> getOutlets() async {
    try {
      final response = await _retryRequest(
        () => _makeRequest('$baseUrl$outletMenusEndpoint'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Outlet.fromJson(json)).toList();
      } else if (response.statusCode == 403) {
        throw Exception('Access blocked. Please try again later.');
      } else {
        throw Exception(
          'Server error: Failed to load outlets (Status: ${response.statusCode})',
        );
      }
    } on FormatException {
      throw Exception('Invalid data format received from server');
    } on TimeoutException {
      throw Exception(
        'Connection timeout. Please check your internet connection and try again',
      );
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Please check your internet connection');
      }
      throw Exception(
        'Network error: Unable to fetch outlets. Please try again later',
      );
    }
  }

  String getPdfUrl(String pdfUrl) {
    return '$baseUrl/Menu/$pdfUrl';
  }

  Future<String> fetchPdf(String pdfUrl) async {
    try {
      final directPdfUrl = getPdfUrl(pdfUrl);
      final response = await _retryRequest(
        () => _makeRequest(
          directPdfUrl,
          contentType: 'application/pdf',
          additionalHeaders: {
            'Accept': 'application/pdf',
            'Cache-Control': 'no-cache',
            'Pragma': 'no-cache',
          },
        ),
      );

      if (response.statusCode == 200) {
        return directPdfUrl;
      } else if (response.statusCode == 403) {
        throw Exception('Access blocked. Please try again later.');
      } else {
        throw Exception(
          'Server error: Failed to load PDF (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('Network error: Please check your internet connection');
      }
      throw Exception(
        'Network error: Unable to fetch PDF. Please try again later',
      );
    }
  }
}
