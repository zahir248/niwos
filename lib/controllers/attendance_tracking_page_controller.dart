import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';

class AttendanceController {

  ////////////// Punch In Process ////////////////

  Future<void> submitAttendanceIn(BuildContext context, List<Map<String, dynamic>> tagDataList) async {
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
        Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.submitAttendanceInPath}'),
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
            context: context, // Use the provided context
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error!"),
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
            context: context, // Use the provided context
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

  void showPunchInDialog(BuildContext context, Function startNFCReading) {
    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information!"),
          content: Text("Make sure NFC is turned on in the phone. Tap your phone to the tag."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                startNFCReading();
              },
              child: Text("Ok"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Dismiss"),
            ),
          ],
        );
      },
    );
  }

  ////////////// Punch Out Process ////////////////

  Future<void> submitAttendanceOut(BuildContext context, List<Map<String, dynamic>> tagDataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    print('Sending username: $username'); // Debug line

    for (var data in tagDataList) {
      String dateTime = data['dateTime'];
      String formattedDate = dateTime.split(' ')[0];
      String formattedTime = '${dateTime.split(' ')[1]} ${dateTime.split(
          ' ')[2]}';

      // Prepare the data to be sent to PHP script
      Map<String, dynamic> postData = {
        'username': username,
        'date': formattedDate,
        'time': formattedTime,
      };

      // Send HTTP POST request to PHP script
      var response = await http.post(
        Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.submitAttendanceOutPath}'),
        body: postData,
      );

      if (response.statusCode == 200) {
        // Data successfully submitted to the database
        print('Data submitted successfully.');

        // Check if the response contains the message "Attendance record already exists for today"
        if (response.body.contains(
            "Attendance record already exists for today")) {
          // Display dialog with the message
          showDialog(
            barrierDismissible: false, // Prevent dismissal by tapping outside
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error!"),
                content: Text("You already punched out for today."),
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

  void showPunchOutDialog(BuildContext context, Function startPunchOutNFCReading) {
    // Dialog implementation for Punch Out
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information!"),
          content: Text("Make sure NFC is turned on in the phone. Tap your phone to the tag."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Call the method in the view class
                startPunchOutNFCReading();
              },
              child: Text("Ok"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Dismiss"),
            ),
          ],
        );
      },
    );
  }
}
