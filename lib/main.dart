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
  static final String baseIpAddress = "10.200.116.53";

  static const String checkUsernamePath = '/niwos_api/check_username.php';
  static const String securityPicturePath = '/niwos_api/get_picture.php';
  static const String authenticateUserPath = '/niwos_api/authenticate_user.php';
  static const String getUserDataPath = '/niwos_api/get_user_data.php';
  static const String getUserProfileDataPath = '/niwos_api/get_user_profile_data.php';
  static const String uploadImageProfilePath = '/niwos_api/upload_profile_image.php';
  static const String submitAttendanceInPath = '/niwos_api/submit_attendance_in.php';
  static const String submitAttendanceOutPath = '/niwos_api/submit_attendance_out.php';
  static const String retrieveAttendanceHistoryPath = '/niwos_api/retrieve_attendance_history.php';
  static const String submitLeaveRequestPath = '/niwos_api/submit_leave_request.php';
  static const String retrieveLeaveHistoryPath = '/niwos_api/retrieve_leave_history.php';
}
