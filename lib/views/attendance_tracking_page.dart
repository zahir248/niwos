import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/models/attendance_tracking_page_model.dart';

class AttendanceTrackingPage extends StatefulWidget {
  @override
  _AttendanceTrackingPageState createState() =>
      _AttendanceTrackingPageState();
}

class _AttendanceTrackingPageState extends State<AttendanceTrackingPage> {
  bool _isScanning = false;

  void _startNFCReading() {
    setState(() {
      _isScanning = true;
    });

    List<Map<String, dynamic>> tagDataList = [];

    NFCService.startNFCReading(onDiscovered: (String tagData) {
      // Process tag data here
      debugPrint('NFC Tag Data: $tagData');

      // Get current date and time
      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('MM/dd/yyyy hh:mm:ss a').format(now);

      // Store tag data, date, and time together
      tagDataList.add({'tagData': tagData, 'dateTime': formattedDateTime});
    });

    // After a certain delay, stop scanning and display the alert dialog
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isScanning = false; // Stop scanning animation
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
                            '${data['dateTime'].split(' ')[1]} ${data['dateTime'].split(' ')[2]}',
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
                      if (!tagDataList.any((data) => data['tagData'].substring(3) == 'SD#DevC0d3%trngTg2024!'))
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
                      SizedBox(height: 8), // Add spacing between message and buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text(tagDataList.isEmpty ? "Try Again" : "Cancel"), // Change button text conditionally
                          ),
                          SizedBox(width: 8), // Add spacing between buttons
                          TextButton(
                            onPressed: tagDataList.any((data) => data['tagData'].substring(3) == 'SD#DevC0d3%trngTg2024!')
                                ? () {
                              Navigator.pop(context); // Close the dialog
                              _submitAttendance(tagDataList); // Submit attendance manually
                            }
                                : null, // Set onPressed to null if tag data doesn't match
                            child: Text("Submit Attendance"), // Change the button text here
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

  void _submitAttendance(List<Map<String, dynamic>> tagDataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    print('Sending username: $username'); // Debug line

    for (var data in tagDataList) {
      String dateTime = data['dateTime'];
      String formattedDate = dateTime.split(' ')[0];
      String formattedTime = '${dateTime.split(' ')[1]} ${dateTime.split(' ')[2]}';

      // Prepare the data to be sent to PHP script
      Map<String, dynamic> postData = {
        'username': username,
        'date': formattedDate,
        'time': formattedTime,
      };

      // Send HTTP POST request to PHP script
      var response = await http.post(
        Uri.parse('http://10.200.116.53/niwos_api/submit_attendance_in.php'),
        body: postData,
      );

      if (response.statusCode == 200) {
        // Data successfully submitted to the database
        print('Data submitted successfully.');

        // Check if the response contains the message "Attendance record already exists for today"
        if (response.body.contains("Attendance record already exists for today")) {
          // Display dialog with the message
          showDialog(
            barrierDismissible: false, // Prevent dismissal by tapping outside
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Message!"),
                content: Text("You already punched in for today."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else if (response.body.contains("Data inserted successfully")) {
          // Display dialog indicating successful attendance record submission
          showDialog(
            barrierDismissible: false, // Prevent dismissal by tapping outside
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Success!"),
                content: Text("Attendance record successfully taken."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Error occurred
        print('Error: ${response.reasonPhrase}');
      }
    }
  }

  void _showPunchInDialog() {
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Punch In"),
          content: Text("Want to punch in? Tap your phone to the tag."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _startNFCReading(); // Start NFC reading
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

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
                        _isScanning
                            ? CircularProgressIndicator()
                            : Icon(
                          Icons.contactless,
                          size: 40,
                          color: Color(0xFF004AAD),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _isScanning ? 'Scanning...Please wait until done' : 'Punch In',
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
        ],
      ),
    );
  }
}
