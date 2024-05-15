import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/views/login_page.dart';
import '/views/setting_page.dart';
import '../models/user_model.dart';
import '/main.dart';

class DashboardController {
  static void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(context); // Call the logout method
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  static Future<Users> getUserDetailsFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');
      if (username == null) {
        throw Exception('Username not found in SharedPreferences');
      }
      return getUserDetails(username); // Retrieve user details using the obtained username
    } catch (e) {
      throw Exception('Error fetching username from SharedPreferences: $e');
    }
  }

  static Future<Users> getUserDetails(String username) async {
    final response = await http.get(
      Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.getUserDataPath}?username=$username'),
    );

    if (response.statusCode == 200) {
      //print('Response body: ${response.body}');

      final userData = json.decode(response.body);
      //print('Parsed user data: $userData');

      return Users.fromJson(userData);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }

  static void _logout(BuildContext context) {
    // Perform logout actions here
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
