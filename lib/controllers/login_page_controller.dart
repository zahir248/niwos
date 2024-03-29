import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/views/dashboard_page.dart'; // Import the dashboard page
import '/views/security_picture_page.dart'; // Import the security picture page
import '/main.dart'; // Import the main.dart to access AppConfig

class LoginPageController {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  Future<bool> authenticate(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');

      if (username == null || username.isEmpty) {
        // Show a dialog informing the user to login with their username and password first
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Required'),
              content: Text('Please login with your username and password first.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return false;
      }

      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;

      if (!canCheckBiometrics) {
        // Biometric authentication is not available on this device
        // Handle this case accordingly
        return false;
      }

      bool authenticated = await _localAuthentication.authenticate(
        localizedReason: 'Touch the fingerprint sensor',
      );

      if (authenticated) {
        // Navigate to dashboard page if authentication is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        // Return true if authentication is successful
        return true;
      }

      // Return false if authentication fails
      return false;
    } catch (e) {
      print('Authentication failed: $e');
      return false;
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

  Future<void> navigateToSecurityPicturePage(BuildContext context, String username) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecurityPicturePage(username: username)),
      );
    } catch (e) {
      print('Navigation to security picture page failed: $e');
    }
  }
}
