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
  static final String baseIpAddress = "192.168.0.110";

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
  static const String retrieveAccessCodePath = '/niwos_api/retrieve_access_code.php';
  static const String submitAccessRequestPath = '/niwos_api/submit_access_request.php';
  static const String retrieveAccessHistoryPath = '/niwos_api/retrieve_access_history.php';
  static const String retrievePendingLeaveHistoryPath = '/niwos_api/retrieve_pending_leave_history.php';
  static const String updateCancelStatusLeaveRequestPath = '/niwos_api/update_cancel_status_leave_request.php';
  static const String retrievePendingAccessHistoryPath = '/niwos_api/retrieve_pending_access_history.php';
  static const String updateCancelStatusAccessRequestPath = '/niwos_api/update_cancel_status_access_request.php';
  static const String retrieveAccessPermissionPath = '/niwos_api/retrieve_access_permission.php';
  static const String walletInformationPath = '/niwos_api/retrieve_wallet_information.php';
  static const String submitPaymentPath = '/niwos_api/submit_payment.php';
  static const String updateWalletBalancePath = '/niwos_api/update_wallet_balance.php';
  static const String retrieveTransactionPath = '/niwos_api/retrieve_transaction.php';
  static const String uploadSecurityImagePath = '/niwos_api/upload_security_image.php';
  static const String updateUsernamePath = '/niwos_api/update_username.php';
  static const String changePasswordPath = '/niwos_api/change_password.php';
  static const String submitFeedbackPath = '/niwos_api/submit_feedback.php';
  static const String retrieveNotificationsPath = '/niwos_api/retrieve_notifications.php';
  static const String retrieveUsernamePath = '/niwos_api/retrieve_username.php';
  static const String resetPasswordPath = '/niwos_api/reset_password.php';
  static const String submitAttendanceQRPath = '/niwos_api/submit_attendance_qr.php';
}