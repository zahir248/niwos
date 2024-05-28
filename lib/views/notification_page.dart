import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/notification_page_controller.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationItem> notifications = [];
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUsernameAndFetchNotifications();
  }

  Future<void> _loadUsernameAndFetchNotifications() async {
    String? loadedUsername = await NotificationController.loadUsername();
    if (loadedUsername != null) {
      setState(() {
        username = loadedUsername;
      });
      _fetchNotifications();
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      List<NotificationItem> fetchedNotifications = await NotificationController.fetchNotifications(username!);
      setState(() {
        notifications = fetchedNotifications;
      });
    } catch (e) {
      print('Error fetching notifications: $e');
      // Handle error, maybe show a snackbar or display an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Notification'),
      ),
      body: Container(
        color: Colors.grey[350],
        child: notifications.isEmpty
            ? Center(
          child: Text(
            'No notification for now',
            style: TextStyle(fontSize: 18.0),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(notification: notification);
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    List<String> dateTimeParts = notification.timestamp.split(' ');
    String date = dateTimeParts[0];
    String time = dateTimeParts[1];

    String formattedDate = _formatDate(notification.message);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              notification.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              notification.message,
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  String _formatDate(String message) {
    RegExp regex = RegExp(r'Submitted on: (\d{4}-\d{2}-\d{2} \d{2}:\d{2} [AP]M)');
    String? dateString = regex.firstMatch(message)?.group(1);

    if (dateString != null) {
      DateTime dateTime = DateFormat("yyyy-MM-dd hh:mm a").parse(dateString);
      String formattedDate = DateFormat.yMMMMd().add_jm().format(dateTime);
      return formattedDate;
    } else {
      return "Invalid date";
    }
  }
}