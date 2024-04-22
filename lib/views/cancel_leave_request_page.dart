import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/cancel_leave_request_page_controller.dart';

class CancelLeaveRequestPage extends StatefulWidget {
  @override
  _CancelLeaveRequestPageState createState() => _CancelLeaveRequestPageState();
}

class _CancelLeaveRequestPageState extends State<CancelLeaveRequestPage> {
  final CancelLeaveRequestController _controller =
  CancelLeaveRequestController();
  List<dynamic> pendingLeaveData = [];

  @override
  void initState() {
    super.initState();
    _loadPendingLeaveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Cancel Leave Request'),
      ),
      backgroundColor: Colors.grey[350],
      body: pendingLeaveData.isEmpty
          ? Center(
        child: Text(
          'No pending leave request found',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: pendingLeaveData.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> leave = pendingLeaveData[index];
          String startDate = leave['StartDate'];
          String endDate = leave['EndDate'];
          int duration = leave['Duration'] != null
              ? int.parse(leave['Duration'])
              : 0;
          String? reason = leave['Reason'];
          String submissionTimeDate = leave['SubmissionTimeDate'];
          String status = leave['Status'];

          String type = leave['Type'];

          DateTime submissionDateTime =
          DateTime.parse(submissionTimeDate);
          String formattedDate =
          DateFormat('EEEE, d MMMM yyyy').format(submissionDateTime);
          String formattedTime =
          DateFormat('h:mm a').format(submissionDateTime);

          return Card(
            elevation: 3,
            margin:
            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 16, horizontal: 20),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: 90,
                        padding: EdgeInsets.symmetric(
                            vertical: 7, horizontal: 10),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status),
                        ),
                        child: Text(
                          '$status',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 0.3,
                    color: Colors.black,
                    margin: EdgeInsets.symmetric(vertical: 8),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text(
                              formattedDate,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 8),
                            Text(
                              formattedTime,
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _cancelLeaveRequest(leave, context);
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 50)),
                      shape: MaterialStateProperty.all<
                          RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.red.shade900),
                    ),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadPendingLeaveData() async {
    try {
      final List<dynamic> data = await _controller.fetchPendingLeaveData();
      data.sort((a, b) {
        // Parse date and time strings into DateTime objects
        DateTime dateTimeA = DateTime.parse(a['SubmissionTimeDate']);
        DateTime dateTimeB = DateTime.parse(b['SubmissionTimeDate']);
        // Compare DateTime objects
        return dateTimeB.compareTo(dateTimeA); // Sort in descending order
      });
      setState(() {
        pendingLeaveData = data;
      });
    } catch (error) {
      if (error is FormatException) {
        // Handle FormatException gracefully (optional)
        // For example, you can display a custom error message to the user
      } else {
        print(error);
      }
    }
  }

  void _cancelLeaveRequest(Map<String, dynamic> leave, BuildContext context) async {
    try {
      final leaveRequestId = leave['LeaveRequest_ID']; // Extract LeaveRequest_ID
      final requestData = {'LeaveRequest_ID': leaveRequestId}; // Prepare request data

      // Show confirmation dialog
      final isCancelled = await showDialog(
        barrierDismissible: false, // Prevent dismissal by tapping outside
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation!'),
            content: Text('Are you sure you want to cancel this leave request?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Close the dialog
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  // Close the dialog and cancel the leave request
                  Navigator.of(context).pop(true);
                  await _executeCancellation(requestData, context);
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      );

      if (isCancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your leave request has been successfully cancelled.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green[900],
          ),
        );
      }
    } catch (error) {
      print(error);
      // Handle cancellation error, if any
    }
  }

  // Method to execute the leave request cancellation
  Future<void> _executeCancellation(Map<String, dynamic> requestData, BuildContext context) async {
    try {
      await _controller.cancelLeaveRequest(requestData);
      // Reload pending leave data after cancellation
      _loadPendingLeaveData();
      // Redirect to previous page
      Navigator.of(context).pop();
    } catch (error) {
      print(error);
      // Handle cancellation error, if any
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.yellow.shade700;
      case 'Approved':
        return Colors.green.shade900;
      case 'Rejected':
        return Colors.red.shade900;
      default:
        return Colors.blue.shade900;
    }
  }
}