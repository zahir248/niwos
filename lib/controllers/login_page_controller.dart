import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/views/dashboard_page.dart'; // Import the dashboard page
import '/views/security_picture_page.dart'; // Import the security picture page
import '/main.dart'; // Import the main.dart to access AppConfig

class LoginPageController {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<void> authenticate(BuildContext context) async {
    try {
      // Check if biometric authentication is available
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

      if (!canCheckBiometrics) {
        // Biometric authentication is not available on this device
        // Handle this case accordingly
        return;
      }

      // Authenticate with biometrics
      bool authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to login', // Reason for authentication
      );

      if (authenticated) {
        // Navigate to dashboard page if authentication is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      }
    } catch (e) {
      // Handle authentication errors
      print('Authentication failed: $e');
    }
  }

  Future<bool> checkUsername(String username) async {
    try {
      // Debugging line to print the username value
      print('Sending username to server: $username');

      final response = await http.post(
        Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.checkUsernamePath}'), // Construct the server URL using AppConfig
        body: {'username': username},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Assuming the response contains a key 'exists'
        bool exists = data['exists'];
        return exists;
      } else {
        throw Exception('Failed to check username');
      }
    } catch (e) {
      print('Username check failed: $e');
      return false;
    }
  }

  Future<void> navigateToSecurityPicturePage(BuildContext context) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecurityPicturePage()),
      );
    } catch (e) {
      print('Navigation to security picture page failed: $e');
    }
  }
}
