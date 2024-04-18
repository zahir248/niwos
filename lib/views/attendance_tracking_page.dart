import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/models/attendance_tracking_page_model.dart';
import '/controllers/attendance_tracking_page_controller.dart';
import '/views/attendance_history_page.dart';
import '/views/leave_history_page.dart';
import '/views/leave_request_page.dart';

class AttendanceTrackingPage extends StatefulWidget {
  @override
  _AttendanceTrackingPageState createState() =>
      _AttendanceTrackingPageState();
}

class _AttendanceTrackingPageState extends State<AttendanceTrackingPage> {

  final AttendanceController _attendanceController = AttendanceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Attendance Tracking'),
      ),
      backgroundColor: Colors.grey[350],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(60, 16, 60, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      // Display Punch In dialog
                      _showPunchInDialog();
                    },
                    child: Column(
                      children: [
                        _isPunchInScanning
                            ? CircularProgressIndicator()
                            : Icon(
                          Icons.contactless,
                          size: 40,
                          color: Color(0xFF004AAD),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _isPunchInScanning
                              ? 'Scanning...Please wait until done'
                              : 'Punch In',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      _showPunchOutDialog();
                    },
                    child: Column(
                      children: [
                        _isPunchOutScanning
                            ? CircularProgressIndicator()
                            : Icon(
                          Icons.contactless,
                          size: 40,
                          color: Color(0xFF004AAD),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _isPunchOutScanning
                              ? 'Scanning...Please wait until done'
                              : 'Punch Out',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AttendanceHistoryPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View Attendance History",
                          style: TextStyle(
                            color: Color(0xFF004AAD),
                            fontSize: 15, // Adjust the font size as needed
                          ),
                        ),
                        SizedBox(width: 10), // Add space between text and icon
                        Icon(
                          Icons.arrow_forward_ios, // Icon for navigating forward
                          color: Color(0xFF004AAD),
                          size: 15, // Adjust the icon size as needed
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubmitLeaveRequestPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Submit Leave Request",
                          style: TextStyle(
                            color: Color(0xFF004AAD),
                            fontSize: 15, // Adjust the font size as needed
                          ),
                        ),
                        SizedBox(width: 10), // Add space between text and icon
                        Icon(
                          Icons.arrow_forward_ios, // Icon for navigating forward
                          color: Color(0xFF004AAD),
                          size: 15, // Adjust the icon size as needed
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewLeaveRequestHistoryPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "View Leave Request History",
                          style: TextStyle(
                            color: Color(0xFF004AAD),
                            fontSize: 15, // Adjust the font size as needed
                          ),
                        ),
                        SizedBox(width: 8), // Add space between text and icon
                        Icon(
                          Icons.arrow_forward_ios, // Icon for navigating forward
                          color: Color(0xFF004AAD),
                          size: 15, // Adjust the icon size as needed
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  ////////////// Punch In Process ////////////////

  bool _isPunchInScanning = false;

  void _showPunchInDialog() {
    _attendanceController.showPunchInDialog(context, _startPunchInNFCReading);
  }

  void _startPunchInNFCReading() {
    setState(() {
      _isPunchInScanning = true;
    });

    List<Map<String, dynamic>> tagDataList = [];

    NFCService.startPunchInNFCReading(onDiscovered: (String tagData) {
      // Process tag data here
      debugPrint('NFC Tag Data: $tagData');

      // Get current date and time
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('MM/dd/yyyy hh:mm:ss a').format(
          now);

      // Store tag data, date, and time together
      tagDataList.add({'tagData': tagData, 'dateTime': formattedDateTime});
    });

    // After a certain delay, stop scanning and display the alert dialog
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isPunchInScanning = false;
      });

      // Show alert dialog with tag data, date, and time if available; otherwise, display "Please scan again"
      showDialog(
        barrierDismissible: false, // Prevent dismissal by tapping outside
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Punch In Information"),
            content: tagDataList.isEmpty
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tap the phone for a longer time."),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text("Dismiss"), // Button to dismiss the dialog
                    ),
                  ),
                ),
              ],
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tagDataList.map((data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8), // Add space here
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${data['dateTime'].split(' ')[0]}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8), // Add space here
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Time: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                            '${data['dateTime'].split(
                                ' ')[1]} ${data['dateTime'].split(' ')[2]}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            // Inside the AlertDialog widget in the _startNFCReading method
            actions: [
              if (tagDataList.isNotEmpty)
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!tagDataList.any((data) =>
                      data['tagData'].substring(3) == 'SD#DevC0d3%trngTg2024!'))
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.red, // Set the background color
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Message: Invalid NFC tag!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      SizedBox(height: 8),
                      // Add spacing between message and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text(tagDataList.isEmpty
                                ? "Try Again"
                                : "Cancel"), // Change button text conditionally
                          ),
                          SizedBox(width: 8), // Add spacing between buttons
                          TextButton(
                            onPressed: tagDataList.any((data) =>
                            data['tagData'].substring(3) ==
                                'SD#DevC0d3%trngTg2024!')
                                ? () {
                              Navigator.pop(context); // Close the dialog
                              _attendanceController.submitAttendanceIn(context, tagDataList); // Call the method through the controller// Submit attendance manually
                            }
                                : null,
                            // Set onPressed to null if tag data doesn't match
                            child: Text(
                                "Submit Attendance"), // Change the button text here
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      );
    });
  }

  ////////////// Punch Out Process ////////////////

  bool _isPunchOutScanning = false;

  void _showPunchOutDialog() {
    _attendanceController.showPunchOutDialog(context, _startPunchOutNFCReading);
  }

  void _startPunchOutNFCReading() {
    setState(() {
      _isPunchOutScanning = true;
    });

    List<Map<String, dynamic>> tagDataList = [];

    NFCService.startPunchOutNFCReading(onDiscovered: (String tagData) {
      // Process tag data here
      debugPrint('NFC Tag Data: $tagData');

      // Get current date and time
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('MM/dd/yyyy hh:mm:ss a').format(
          now);

      // Store tag data, date, and time together
      tagDataList.add({'tagData': tagData, 'dateTime': formattedDateTime});
    });

    // After a certain delay, stop scanning and display the alert dialog
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isPunchOutScanning = false;
      });

      // Show alert dialog with tag data, date, and time if available; otherwise, display "Please scan again"
      showDialog(
        barrierDismissible: false, // Prevent dismissal by tapping outside
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Punch Out Information"),
            content: tagDataList.isEmpty
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tap the phone for a longer time."),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                      child: Text("Dismiss"), // Button to dismiss the dialog
                    ),
                  ),
                ),
              ],
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tagDataList.map((data) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8), // Add space here
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Date: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '${data['dateTime'].split(' ')[0]}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8), // Add space here
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(
                            text: 'Time: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                            '${data['dateTime'].split(
                                ' ')[1]} ${data['dateTime'].split(' ')[2]}',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
            // Inside the AlertDialog widget in the _startNFCReading method
            actions: [
              if (tagDataList.isNotEmpty)
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!tagDataList.any((data) =>
                      data['tagData'].substring(3) == 'SD#DevC0d3%trngTg2024!'))
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.red, // Set the background color
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Message: Invalid NFC tag!",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      SizedBox(height: 8),
                      // Add spacing between message and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text(tagDataList.isEmpty
                                ? "Try Again"
                                : "Cancel"), // Change button text conditionally
                          ),
                          SizedBox(width: 8), // Add spacing between buttons
                          TextButton(
                            onPressed: tagDataList.any((data) =>
                            data['tagData'].substring(3) ==
                                'SD#DevC0d3%trngTg2024!')
                                ? () {
                              Navigator.pop(context); // Close the dialog
                              _attendanceController.submitAttendanceOut(
                                  context,
                                  tagDataList
                              ); // Submit attendance manually
                            }
                                : null,
                            // Set onPressed to null if tag data doesn't match
                            child: Text(
                                "Submit Attendance"), // Change the button text here
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      );
    });
  }
}



