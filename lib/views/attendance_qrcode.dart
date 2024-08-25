import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '/main.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final String targetString = 'SD#DevC0d3%trngTg2024!';

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (result == null && scanData.code == targetString) {
        setState(() {
          result = scanData;
        });
        controller.stopCamera(); // Stop the QR scanner
        _navigateToNextPage();
      }
    });
  }

  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AttendanceFormPage()),
    ).then((_) {
      // Reset result to null if you want to allow scanning again when returning to the QR scanner
      setState(() {
        result = null;
      });
      controller?.resumeCamera(); // Resume the QR scanner if needed
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class AttendanceFormPage extends StatefulWidget {
  @override
  _AttendanceFormPageState createState() => _AttendanceFormPageState();
}

class _AttendanceFormPageState extends State<AttendanceFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPunchType;

  final String _serverUrl = 'http://${AppConfig.baseIpAddress}${AppConfig.submitAttendanceQRPath}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Attendance Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Attendance Type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Column(
                  children: <Widget>[
                    RadioListTile<String>(
                      title: Text(
                        'Punch In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: 'Punch In',
                      groupValue: _selectedPunchType,
                      onChanged: (value) {
                        setState(() {
                          _selectedPunchType = value;
                        });
                      },
                    ),
                    Divider(),
                    RadioListTile<String>(
                      title: Text(
                        'Punch Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: 'Punch Out',
                      groupValue: _selectedPunchType,
                      onChanged: (value) {
                        setState(() {
                          _selectedPunchType = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_selectedPunchType != null) {
                      _showDateTimeDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'Please select Punch In or Punch Out')),
                      );
                    }
                  },
                  icon: Icon(Icons.check_circle, color: Colors.white),
                  label: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF004AAD),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDateTimeDialog(BuildContext context) {
    // Get the current date and time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('MM/dd/yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now); // Use 24-hour format

    showDialog(
      barrierDismissible: false, // Prevent dismissal by tapping outside
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize vertical space
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Attendance Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Type: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: _selectedPunchType ?? '',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: formattedDate,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Time: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: formattedTime,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Are you sure you want to submit attendance now?',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        DateTime now = DateTime.now();
                        DateTime punchInStartTime = DateTime(now.year, now.month, now.day, 8, 55);
                        DateTime punchInEndTime = DateTime(now.year, now.month, now.day, 18, 0);
                        DateTime punchOutStartTime = DateTime(now.year, now.month, now.day, 18, 0);
                        DateTime punchOutEndTime = DateTime(now.year, now.month, now.day + 1, 8, 0); // 8:00 AM next day

                        if (_selectedPunchType == 'Punch In') {
                          // Check if the current time is within the allowed range for Punch In
                          if (now.isBefore(punchInStartTime) || now.isAfter(punchInEndTime)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Punch In can only be submitted between 8:55 AM and 6:00 PM'),
                                backgroundColor: Colors.red[900],
                                duration: Duration(seconds: 5),
                              ),
                            );
                          } else {
                            // Send data to server
                            bool success = await _submitAttendance(formattedDate, formattedTime);
                            if (success) {
                              Navigator.of(context).pop(); // Close the dialog
                            }
                          }
                        } else if (_selectedPunchType == 'Punch Out') {
                          // Check if the current time is within the allowed range for Punch Out
                          if (now.isBefore(punchOutStartTime) && now.isAfter(punchOutEndTime)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Punch Out can only be submitted between 6:00 PM and 8:00 AM'),
                                backgroundColor: Colors.red[900],
                                duration: Duration(seconds: 5),
                              ),
                            );
                          } else {
                            // Send data to server
                            bool success = await _submitAttendance(formattedDate, formattedTime);
                            if (success) {
                              Navigator.of(context).pop(); // Close the dialog
                            }
                          }
                        }
                      },
                      child: Text('Confirm'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF004AAD), // Set your button color here
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _submitAttendance(String date, String time) async {
    try {
      // Retrieve the username from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');

      if (username == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username not found. Please log in again.')),
        );
        return false;
      }

      // Log the data being sent to the server
      print('Sending data to server:');
      print('username: $username');
      print('punchType: $_selectedPunchType');
      print('date: $date');
      print('time: $time');

      final response = await http.post(
        Uri.parse(_serverUrl),
        body: {
          'username': username, // Include username in the POST request
          'punchType': _selectedPunchType!,
          'date': date,
          'time': time,
        },
      );

      // Log the server response
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the server response to check if the submission was successful
        final responseData = json.decode(response.body);

        if (responseData['success']) {
          // Handle successful submission
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Attendance successfully submitted'),
              backgroundColor: Colors.green[900],
              duration: Duration(seconds: 5),
            ),
          );
          return true;
        } else {
          // Handle the case where attendance submission failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
                responseData['message'] ?? 'Failed to submit attendance.'),
              backgroundColor: Colors.red[900],
            ),
          );
          return false;
        }
      } else {
        // Handle failure due to server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit attendance. Server error.'),
            backgroundColor: Colors.red[900],
          ),
        );
        return false;
      }
    } catch (e) {
      // Log the error
      print('Error submitting attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit attendance.'),
          backgroundColor: Colors.red[900],
        ),
      );
      return false;
    }
  }
}