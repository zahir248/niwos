import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';

class CancelAccessRequestController {
  Future<List<dynamic>> fetchPendingAccessData() async {
    final String? username = await getUsername();

    if (username != null && username.isNotEmpty) {
      final url = Uri.parse(
          'http://${AppConfig.baseIpAddress}${AppConfig.retrievePendingAccessHistoryPath}?username=$username');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load pending access data');
      }
    } else {
      throw Exception('Username not found');
    }
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> cancelAccessRequest(Map<String, dynamic> requestData) async {
    // Implement cancellation logic here
    print('Request Data: $requestData'); // Debug line
    final url = Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.updateCancelStatusAccessRequestPath}');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      print('Access request cancelled successfully');
      // Optionally, you can handle success here
    } else {
      throw Exception('Failed to cancel access request');
    }
  }
}