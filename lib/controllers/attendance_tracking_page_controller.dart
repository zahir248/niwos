import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '/main.dart';

class AttendanceController {
  Future<void> submitAttendanceIn(BuildContext context, List<Map<String, dynamic>> tagDataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    print('Sending username: $username'); // Debug line

    for (var data in tagDataList) {
      String dateTime = data['dateTime'];
      // Parse the date and time from formattedDateTime
      DateTime parsedDateTime = DateFormat('MM/dd/yyyy hh:mm:ss a').parse(dateTime);

      // Format the date and time in the desired format
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDateTime);
      String formattedTime = DateFormat('HH:mm:ss').format(parsedDateTime);

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

      // Debug line to print the response from the server
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Data successfully submitted to the database
        print('Data submitted successfully.');

        // Check if the response contains the message "Attendance record already exists for today"
        if (response.body.contains("Attendance record already exists for today")) {
          // Extract the time from the response
          String existingTime = extractTimeFromResponse(response.body);

          // Display dialog with the message
          showDialog(
            barrierDismissible: false, // Prevent dismissal by tapping outside
            context: context, // Use the provided context
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error!"),
                content: Text("You already punched in for today at $existingTime."),
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

  Future<void> submitAttendanceOut(BuildContext context, List<Map<String, dynamic>> tagDataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    print('Sending username: $username'); // Debug line

    for (var data in tagDataList) {
      String dateTime = data['dateTime'];
      // Parse the date and time from formattedDateTime
      DateTime parsedDateTime = DateFormat('MM/dd/yyyy hh:mm:ss a').parse(dateTime);

      // Format the date and time in the desired format
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDateTime);
      String formattedTime = DateFormat('HH:mm:ss').format(parsedDateTime);

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

      // Debug line to print the response from the server
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Data successfully submitted to the database
        print('Data submitted successfully.');

        // Check if the response contains the message "Attendance record already exists for today"
        if (response.body.contains("Attendance record already exists for today")) {
          // Extract the time from the response
          String existingTime = extractTimeFromResponse(response.body);

          // Display dialog with the message
          showDialog(
            barrierDismissible: false, // Prevent dismissal by tapping outside
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error!"),
                content: Text("You already punched out for today at $existingTime."),
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

  String extractTimeFromResponse(String responseBody) {
    RegExp timeRegExp = RegExp(r'(Punch-in|Punch-out) time: (\d{2}:\d{2}:\d{2})');
    Match? match = timeRegExp.firstMatch(responseBody);
    if (match != null) {
      String rawTime = match.group(2) ?? 'unknown time'; // Extract time
      //print('Raw time: $rawTime');
      // If the raw time string contains AM/PM, remove it before parsing
      String cleanedTime = rawTime.replaceAll(RegExp(r'[AP]M'), '');
      // Parse the cleaned time string and format it
      DateTime parsedTime = DateFormat('HH:mm:ss').parse(cleanedTime);
      String formattedTime = DateFormat('h:mm a').format(parsedTime);
      return formattedTime;
    } else {
      return 'unknown time';
    }
  }

}
