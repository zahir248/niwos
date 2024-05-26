import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';

class FeedbackController {
  late String? username;

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
  }

  Future<void> submitFeedback({
    required String problemDescription,
    required String featureArea,
    required String severity,
    required String problemDetails,
    required String impact,
    required String frequency,
    required String additionalComments,
    required Function(bool isSuccess) onSubmitResult,
  }) async {
    // Check if username is available
    if (username == null) {
      onSubmitResult(false);
      return;
    }

    // Prepare the data to be sent
    Map<String, String> data = {
      'problemDescription': problemDescription,
      'featureArea': featureArea,
      'severity': severity,
      'problemDetails': problemDetails,
      'impact': impact,
      'frequency': frequency,
      'additionalComments': additionalComments,
      'username': username!,
    };

    // Construct the URL for submitting feedback
    String submitFeedbackUrl = 'http://${AppConfig.baseIpAddress}${AppConfig.submitFeedbackPath}';

    // Send the data to the PHP script
    final response = await http.post(
      Uri.parse(submitFeedbackUrl),
      body: data,
    );

    // Check the response
    if (response.statusCode == 200) {
      // Feedback submitted successfully
      onSubmitResult(true);
    } else {
      // Error submitting feedback
      onSubmitResult(false);
    }
  }
}