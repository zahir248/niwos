import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';

class NotificationController {
  static Future<String?> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  static Future<List<NotificationItem>> fetchNotifications(String username) async {
    final response = await http.post(
      Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.retrieveNotificationsPath}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> notificationJson = json.decode(response.body);
      return notificationJson.map((json) => NotificationItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String timestamp;

  NotificationItem({
    required this.title,
    required this.message,
    required this.timestamp,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
}