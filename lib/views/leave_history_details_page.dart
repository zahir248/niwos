import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveDetailsPage extends StatelessWidget {
  final Map<String, dynamic> leave;

  LeaveDetailsPage({required this.leave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Leave Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTile('Type:', leave['Type']),
            _buildTile('Start Date:', _formatDate(leave['StartDate'])),
            _buildTile('End Date:', _formatDate(leave['EndDate'])),
            _buildTile('Duration:', leave['Duration'] != null ? '${leave['Duration']} days' : 'Not specified'),
            _buildTile('Reason:', leave['Reason'] ?? 'Not specified'),
            _buildTile('Status:', leave['Status']),
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
}
