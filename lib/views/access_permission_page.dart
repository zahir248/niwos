import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/access_permission_page_controller.dart';

class AccessPermissionPage extends StatefulWidget {
  @override
  _AccessPermissionPageState createState() => _AccessPermissionPageState();
}

class _AccessPermissionPageState extends State<AccessPermissionPage> {
  final AccessPermissionController _controller = AccessPermissionController();
  List<dynamic> accessPermissionData = [];

  @override
  void initState() {
    super.initState();
    _loadAccessPermissionData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Access Permission'),
      ),
      backgroundColor: Colors.grey[350],
      body: _buildAccessPermissionList(),
    );
  }

  Widget _buildAccessPermissionList() {
    if (accessPermissionData.isEmpty) {
      return Center(
        child: Text(
          'No access permission found',
          style: TextStyle(fontSize: 16),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: accessPermissionData.length,
        itemBuilder: (context, index) {
          var permission = accessPermissionData[index];
          // Convert string to DateTime
          DateTime startTime = DateTime.parse(permission['StartTimeDate']);
          DateTime endTime = DateTime.parse(permission['EndTimeDate']);
          // Format the date and time values
          String startTimeFormatted = DateFormat('EEEE, d MMMM yyyy').format(startTime);
          String endTimeFormatted = DateFormat('EEEE, d MMMM yyyy').format(endTime);
          String startTimeFormattedTime = DateFormat('hh:mm a').format(startTime);
          String endTimeFormattedTime = DateFormat('hh:mm a').format(endTime);
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Color(0xFF004AAD),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the child
                    children: [
                      Text(
                        permission['AreaName'],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Make text bold
                      ),
                      Text(
                        startTimeFormatted,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        startTimeFormattedTime,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'End:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Make text bold
                      ),
                      Text(
                        endTimeFormatted,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        endTimeFormattedTime,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _loadAccessPermissionData() async {
    try {
      final List<dynamic> data = await _controller.fetchAccessPermissionData();
      setState(() {
        accessPermissionData = data;
      });
    } catch (error) {
      print(error);
    }
  }
}