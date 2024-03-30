import 'package:flutter/material.dart';

import 'views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class AppConfig {
  static final String baseIpAddress = "10.200.114.31";

  static const String checkUsernamePath = '/niwos_api/check_username.php';
  static const String securityPicturePath = '/niwos_api/get_picture.php';
  static const String authenticateUserPath = '/niwos_api/authenticate_user.php';
  static const String getUserDataPath = '/niwos_api/get_user_data.php';
}
