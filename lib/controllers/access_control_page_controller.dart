import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '/main.dart';

class AccessController {
  Future<List<String>> fetchUserAccessCodes(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    // Print the username for debugging
    print('Username retrieved: $username');

    try {
      // Send a POST request to your PHP script with the username
      final response = await http.post(
        Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.retrieveAccessCodePath}'),
        body: {'username': username},
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response to extract the access codes
        List<dynamic> accessCodesJson = json.decode(response.body);
        List<String> accessCodes = accessCodesJson.cast<String>();

        // Debug print to see the retrieved access codes
        print('Access codes retrieved: $accessCodes');

        return accessCodes;
      } else {
        // If the request fails, return an empty list
        print('Failed to fetch user access codes: ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      // If an exception occurs, return an empty list
      print('Error fetching user access codes: $e');
      return [];
    }
  }

  void showAccessDialog(BuildContext context, Function startNFCReading) {
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information!"),
          content: Text("Make sure NFC is turned on in the phone. Tap your phone to the tag."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                startNFCReading();
              },
              child: Text("Ok"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Dismiss"),
            ),
          ],
        );
      },
    );
  }
}