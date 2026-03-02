import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class UpdateService {
  static const String updateUrl = 'https://pufood.xyz/app/app.json';

  Future<Map<String, dynamic>> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform().catchError((e) {
        throw Exception('Failed to retrieve package info: $e');
      });

      final response = await http
          .get(Uri.parse(updateUrl))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timed out'),
          );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch update data: ${response.statusCode}');
      }

      final updateData = jsonDecode(response.body);
      if (updateData is! Map<String, dynamic>) {
        throw Exception('Invalid update data format');
      }

      if (!updateData.containsKey('version') ||
          !updateData.containsKey('apk_url') ||
          !updateData.containsKey('release_notes')) {
        throw Exception('Missing required fields in update data');
      }

      final serverVersion = updateData['version'] as String;
      final currentVersion = packageInfo.version;

      final bool updateAvailable = _compareVersions(
        serverVersion,
        currentVersion,
      );

      return {
        'updateAvailable': updateAvailable,
        'serverVersion': serverVersion,
        'currentVersion': currentVersion,
        'apkUrl': updateData['apk_url'] as String,
        'releaseNotes': updateData['release_notes'] as String,
      };
    } catch (e) {
      throw Exception('Error checking for updates: $e');
    }
  }

  bool _compareVersions(String serverVersion, String currentVersion) {
    try {
      final serverParts =
          serverVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
      final currentParts =
          currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

      final maxLength =
          serverParts.length > currentParts.length
              ? serverParts.length
              : currentParts.length;
      serverParts.addAll(List.filled(maxLength - serverParts.length, 0));
      currentParts.addAll(List.filled(maxLength - currentParts.length, 0));

      for (var i = 0; i < maxLength; i++) {
        if (serverParts[i] > currentParts[i]) return true;
        if (serverParts[i] < currentParts[i]) return false;
      }
      return false;
    } catch (e) {
      print('Error comparing versions: $e');
      return false;
    }
  }
}
