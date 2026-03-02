import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/update_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isAboutExpanded = false;
  bool _isPrivacyExpanded = false;
  bool _isTermsExpanded = false;
  final UpdateService _updateService = UpdateService();

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/iad1tya');
    if (!await launchUrl(url)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch Telegram')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: const Text(
                'About App',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isAboutExpanded = expanded;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PUFood is a food price comparison platform designed for Parul University students and faculty. Created by Aditya Yadav, a Computer Science student, PUFood simplifies finding the best food deals across campus outlets. Inspired by the challenges of navigating dining options, PUFood offers a user-friendly solution to compare menus and prices, saving time and enhancing the dining experience for the university community.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Version 1.0.1',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: const Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isPrivacyExpanded = expanded;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'We respect your privacy and are committed to protecting your personal data. This privacy policy explains how we collect, use, and safeguard your information when you use PUFood:\n\n'
                    '1. Information Collection: We may collect personal information such as your name and email when you register or contact us.\n'
                    '2. Usage: Your data is used to improve our services, personalize your experience, and communicate with you.\n'
                    '3. Data Protection: We implement appropriate security measures to protect your information from unauthorized access.\n'
                    '4. Third Parties: We do not sell or share your personal information with third parties except as required by law.\n'
                    '5. Your Rights: You have the right to access, correct, or delete your personal data.\n\n'
                    'For any privacy-related questions, please contact us via Telegram.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: const Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isTermsExpanded = expanded;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'By using PUFood, you agree to these Terms & Conditions:\n\n'
                    '1. Acceptance: Using our app constitutes acceptance of these terms.\n'
                    '2. Usage: The app is intended for personal use to explore food options at Parul University.\n'
                    '3. Content: All content provided is for informational purposes only. We are not responsible for inaccuracies in menu or price information.\n'
                    '4. User Conduct: You agree not to misuse the app or attempt to access it unlawfully.\n'
                    '5. Liability: We are not liable for any damages arising from the use of this app.\n'
                    '6. Changes: We reserve the right to modify these terms at any time.\n\n'
                    'For questions about these terms, contact us via Telegram.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: const Text(
                'Check for Updates',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Check for app updates'),
              trailing: const Icon(Icons.system_update, size: 24),
              onTap: () async {
                try {
                  final updateInfo = await _updateService.checkForUpdate();
                  if (!mounted) return;

                  if (updateInfo['updateAvailable']) {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Update Available'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New version ${updateInfo['serverVersion']} is available!',
                                ),
                                const SizedBox(height: 8),
                                Text('${updateInfo['releaseNotes']}'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Later'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final Uri url = Uri.parse(
                                    updateInfo['apkUrl'],
                                  );
                                  if (!await launchUrl(url)) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Could not launch update URL',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text('Update Now'),
                              ),
                            ],
                          ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('App is up to date!')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to check for updates'),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: const Text(
                'Contact Developer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Connect with us on Telegram'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _launchTelegram,
            ),
          ),
        ],
      ),
    );
  }
}
