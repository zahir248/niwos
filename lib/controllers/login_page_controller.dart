import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '/views/dashboard_page.dart'; // Import the dashboard page

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
}
