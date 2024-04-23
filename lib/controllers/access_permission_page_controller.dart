import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';

class AccessPermissionController {
  Future<List<dynamic>> fetchAccessPermissionData() async {
    final String? username = await getUsername();

    if (username != null && username.isNotEmpty) {
      final url = Uri.parse(
          'http://${AppConfig.baseIpAddress}${AppConfig.retrieveAccessPermissionPath}?username=$username');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load access permission data');
      }
    } else {
      throw Exception('Username not found');
    }
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}