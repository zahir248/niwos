import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';

class AccessController {

  Future<List<dynamic>> fetchAccessData(String username) async {

    final url = Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.retrieveAccessHistoryPath}?username=$username');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      // If the server returns a 200 OK response, parse the JSON
      return jsonDecode(response.body);
    } else {
      // If the server response was not OK, throw an error
      throw Exception('Failed to load access history data');
    }
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}