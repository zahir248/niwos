import 'package:flutter/material.dart';

import '/controllers/attendance_history_page_controller.dart';

class AttendanceHistoryPage extends StatefulWidget {
  @override
  _AttendanceHistoryPageState createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  final AttendanceController _controller = AttendanceController();
  List<dynamic> attendanceData = [];
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  @override
  Widget build(BuildContext context) {
    // Filter attendance data if a date is selected
    List<dynamic> filteredAttendanceData = selectedDate != null
        ? attendanceData
        .where((attendance) =>
        attendance['AttendanceDate'].startsWith(selectedDate!.toString().split(' ')[0]))
        .toList()
        : attendanceData;

    // Create a map to hold attendance data grouped by date
    Map<String, List<dynamic>> groupedAttendanceData = {};

    // Group attendance data by date
    filteredAttendanceData.forEach((attendance) {
      String date = attendance['AttendanceDate'];
      if (!groupedAttendanceData.containsKey(date)) {
        groupedAttendanceData[date] = [];
      }
      groupedAttendanceData[date]!.add(attendance);
    });

    // Create a list of ListTile widgets for each date group
    List<Widget> dateGroups = groupedAttendanceData.entries.map<Widget>((entry) {
      String date = entry.key;
      List<dynamic> attendanceRecords = entry.value;

      // Create a ListTile for each date group
      return Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16),
              tileColor: Colors.blue, // Set the background color of the header
              title: Center(
                child: Text(
                  'Date: $date', // Place the date here in the title
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Create a ListTile for each attendance record within the date group
            ...attendanceRecords.map((attendance) {
              // Create a ListTile for each attendance record within the date group
              return ListTile(
                contentPadding: EdgeInsets.all(16),
                tileColor: Colors.white,
                title: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display Session with icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            size: 18,
                            color: attendance['Session'] == 'Out'
                                ? Colors.red
                                : Colors.green,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Session: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${attendance['Session']}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // Display Punch In Time if session is 'In'
                      if (attendance['Session'] == 'In' &&
                          attendance['PunchInTime'] != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 4),
                            Text(
                              'Punch In: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${convertTo12HourFormat(attendance['PunchInTime'])}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      // Display Punch Out Time if session is 'Out'
                      if (attendance['Session'] == 'Out' &&
                          attendance['PunchOutTime'] != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 4),
                            Text(
                              'Punch Out: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${convertTo12HourFormat(attendance['PunchOutTime'])}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 4),
                          Text(
                            'Status: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${attendance['Status']}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      );
    }).toList();

    // If attendance data is empty, display a message
    if (dateGroups.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF004AAD),
          title: Text('Attendance History'),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: _selectDate,
            ),
          ],
        ),
        backgroundColor: Colors.grey[350],
        body: Center(
          child: Text(
            'No attendance records found',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // If attendance data is not empty, display the list of date groups
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Attendance History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _selectDate,
          ),
        ],
      ),
      backgroundColor: Colors.grey[350],
      body: ListView(
        children: dateGroups,
      ),
    );
  }

  void _loadAttendanceData() async {
    try {
      final String? username = await _controller.getUsername();
      if (username != null && username.isNotEmpty) {
        final List<dynamic> data = await _controller.fetchAttendanceData(username);
        data.sort((a, b) => b['AttendanceDate'].compareTo(a['AttendanceDate']));
        setState(() {
          attendanceData = data;
        });
      } else {
        print('Username not found');
      }
    } catch (error) {
      print(error);
    }
  }

  // Function to convert 24-hour format to 12-hour format
  String convertTo12HourFormat(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    String minutes = parts[1];

    String period = 'a.m.';
    if (hour >= 12) {
      period = 'p.m.';
      if (hour > 12) {
        hour -= 12;
      }
    }
    if (hour == 0) {
      hour = 12;
    }
    return '$hour:$minutes $period';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
