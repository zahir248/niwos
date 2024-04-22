import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccessDetailsPage extends StatelessWidget {
  final Map<String, dynamic> access;

  AccessDetailsPage({required this.access});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Access Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTile('Area:', access['AreaName']),
            _buildTile('Start Date:', _formatDate(access['StartTimeDate'])),
            _buildTile('End Date:', _formatDate(access['EndTimeDate'])),
            _buildTile('Duration:', access['Duration'] != null ? _formatDuration(int.parse(access['Duration'])) : 'Not specified'),
            _buildTile('Reason:', access['Reason'] ?? 'Not specified'),
            _buildTile('Status:', access['Status']),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 16.0),
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, left: 16.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  String _formatDate(String dateString) {
    if (dateString != null && dateString.isNotEmpty) {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('EEEE, d MMMM yyyy').format(dateTime);
    } else {
      return 'Not specified';
    }
  }

  String _formatDuration(int durationInMinutes) {
    int days = durationInMinutes ~/ (24 * 60); // Calculate days
    int remainingHours = (durationInMinutes % (24 * 60)) ~/ 60; // Calculate remaining hours
    int remainingMinutes = durationInMinutes % 60; // Calculate remaining minutes

    // Format duration as Days Hours Minutes
    return '$days days $remainingHours hours $remainingMinutes minutes';
  }
}