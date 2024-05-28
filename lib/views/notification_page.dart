import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'System Update',
      message: 'A new system update is available. Please update to the latest version.',
      timestamp: '2024-05-28 10:30 AM',
    ),
    NotificationItem(
      title: 'Meeting Reminder',
      message: 'Don\'t forget the team meeting at 3:00 PM today.',
      timestamp: '2024-05-28 09:00 AM',
    ),
    NotificationItem(
      title: 'New Message',
      message: 'You have received a new message from HR.',
      timestamp: '2024-05-27 04:15 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(notification: notification);
        },
      ),
    );
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
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(notification.message),
            SizedBox(height: 8.0),
            Text(
              notification.timestamp,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}