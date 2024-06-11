import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        ? attendanceData.where((attendance) =>
    attendance['AttendanceDate'] ==
        DateFormat('EEEE, d MMMM yyyy').format(selectedDate!)).toList()
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

      // Create a ListTile for each attendance record within the date group
      return Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 8), // Adjust padding here
              tileColor: Color(0xFF004AAD), // Set the background color of the header
              title: Center(
                child: Text(
                  '$date', // Place the date here in the title
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16), // Adjust font size here
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Display the attendance records in a DataTable
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Session')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Status')),
                ],
                rows: attendanceRecords.map<DataRow>((attendance) {
                  String? punchInTime = attendance['PunchInTime'];
                  String? punchOutTime = attendance['PunchOutTime'];

                  return DataRow(
                    cells: [
                      DataCell(Text('${attendance['Session']}')),
                      DataCell(Text(
                          attendance['Session'] == 'In'
                              ? (punchInTime != null ? convertTo12HourFormat(punchInTime) : 'N/A')
                              : (punchOutTime != null ? convertTo12HourFormat(punchOutTime) : 'N/A')
                      )),
                      DataCell(
                        Container(
                          width: 90, // Adjust the width as needed
                          height: 30, // Adjust the height as needed
                          decoration: BoxDecoration(
                            color: getStatusColor(attendance['Status']), // Get color based on status
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(4), // Adjust border radius as needed
                          ),
                          child: Center(
                            child: Text(
                              attendance['Status'],
                              style: TextStyle(color: Colors.white, fontSize: 11,
                              ), // Text color
                            ),
                          ),
                        ),
                      ), // Close DataCell here
                    ], // Close cells list here
                  );
                }).toList(),
              ),
            ),
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

        // Format the dates in the data list
        data.forEach((attendance) {
          attendance['AttendanceDate'] = DateFormat('EEEE, d MMMM yyyy').format(DateTime.parse(attendance['AttendanceDate']));
        });

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
    int minutes = int.parse(parts[1]);

    String period = 'AM';
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }
    if (hour == 0) {
      hour = 12;
    }
    return '$hour:${minutes.toString().padLeft(2, '0')} $period';
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

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'late':
        return Colors.red.shade900;
      case 'on time':
        return Colors.green.shade900;
      case 'too early':
        return Colors.yellow.shade900;
      case 'on leave':
        return Colors.blueGrey;
      default:
        return Colors.grey.shade900;
    }
  }
}
