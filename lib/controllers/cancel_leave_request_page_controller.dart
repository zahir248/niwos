import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';

class CancelLeaveRequestController {
  Future<List<dynamic>> fetchPendingLeaveData() async {
    final String? username = await getUsername();

    if (username != null && username.isNotEmpty) {
      final url = Uri.parse(
          'http://${AppConfig.baseIpAddress}${AppConfig.retrievePendingLeaveHistoryPath}?username=$username');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load pending leave data');
      }
    } else {
      throw Exception('Username not found');
    }
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> cancelLeaveRequest(Map<String, dynamic> requestData) async {
    // Implement cancellation logic here
    print('Request Data: $requestData'); // Debug line
    final url = Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.updateCancelStatusLeaveRequestPath}');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      print('Leave request cancelled successfully');
      // Optionally, you can handle success here
    } else {
      throw Exception('Failed to cancel leave request');
    }
  }
}