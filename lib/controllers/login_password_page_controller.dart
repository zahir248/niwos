import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/views/dashboard_page.dart';
import '/main.dart';

class LoginPasswordPageController {
  final BuildContext context;

  LoginPasswordPageController(this.context);

  Future<String> authenticateUser(String username, String password) async {
    var url = Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.authenticateUserPath}');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['found']) {
        if (data['status'] == 'active') {
          return 'authenticated';
        } else {
          return 'inactive';
        }
      } else {
        return 'invalid';
      }
    } else {
      throw Exception('Failed to authenticate user');
    }
  }

  void handleLoginButtonPress(String username, String password) async {
    try {
      String authResult = await authenticateUser(username, password);
      if (authResult == 'authenticated') {
        // Store username in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Successful'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green[900],
          ),
        );

        // Navigate to DashboardPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else if (authResult == 'inactive') {
        // Show inactive account message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account is no longer active'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red[900],
          ),
        );
      } else {
        // Show invalid password message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid password'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red[900],
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to authenticate user: $e'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red[900],
        ),
      );
    }
  }
}