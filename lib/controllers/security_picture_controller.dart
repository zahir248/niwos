import 'dart:typed_data';
import 'package:flutter/material.dart';

import '/models/security_picture_model.dart';
import '/views/login_password_page.dart';

class SecurityPictureController {
  Future<Uint8List?> fetchSecurityPicture(String username) async {
    try {
      return await SecurityPictureModel.fetchSecurityPicture(username);
    } catch (e) {
      debugPrint('Error fetching security picture: $e');
      return null;
    }
  }

  Future<void> navigateToLoginPasswordPage(BuildContext context, String username) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPasswordPage(username: username),
        ),
      );
    } catch (e) {
      debugPrint('Navigation to login password page failed: $e');
    }
  }
}