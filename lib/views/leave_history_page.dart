import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/controllers/leave_history_page_controller.dart';
import '/views/leave_history_details_page.dart';

class ViewLeaveRequestHistoryPage extends StatefulWidget {
  @override
  _ViewLeaveRequestHistoryPageState createState() =>
      _ViewLeaveRequestHistoryPageState();
}

class _ViewLeaveRequestHistoryPageState
    extends State<ViewLeaveRequestHistoryPage> {
  final LeaveController _controller = LeaveController();
  List<dynamic> leaveData = [];
  String selectedStatus = 'All'; // Default status filter

  @override
  void initState() {
    super.initState();
    _loadLeaveData();
  }

  @override
  Widget build(BuildContext context) {
    // Filter leave data based on selected status
    List<dynamic> filteredLeaveData = selectedStatus != 'All'
        ? leaveData.where((leave) => leave['Status'] == selectedStatus).toList()
        : leaveData;

    // Reverse the list to display the latest data at the top
    filteredLeaveData = filteredLeaveData.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Leave Request History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[350],
      body: filteredLeaveData.isEmpty
          ? Center(
        child: Text(
          'No leave request records found',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: filteredLeaveData.length,
        itemBuilder: (BuildContext context, int index) {
          // Extract leave request data for the current index
          Map<String, dynamic> leave = filteredLeaveData[index];
          String startDate = leave['StartDate'];
          String endDate = leave['EndDate'];
          int duration =
          leave['Duration'] != null ? int.parse(leave['Duration']) : 0;
          String? reason = leave['Reason'];
          String submissionTimeDate = leave['SubmissionTimeDate'];
          String status = leave['Status'];

          if (selectedStatus != 'All' && status != selectedStatus) {
            return SizedBox.shrink(); // Hide item if not matching filter
          }

          String type = leave['Type'];

          // Format the date and time
          DateTime submissionDateTime = DateTime.parse(submissionTimeDate);
          String formattedDate =
          DateFormat('EEEE, d MMMM yyyy').format(submissionDateTime);
          String formattedTime =
          DateFormat('h:mm a').format(submissionDateTime);

          // Format the data in a ListTile
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              contentPadding:
              EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$type',
                        style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ), // Adjust font size
                      ),
                      Container(
                        width: 90, // Fixed width for the status indicator
                        padding: EdgeInsets.symmetric(
                            vertical: 7, horizontal: 10),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status), // Set color dynamically
                          //borderRadius: BorderRadius.circular(4),
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
                        padding: EdgeInsets.only(bottom: 8), // Add padding to the bottom
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today), // Date icon
                            SizedBox(width: 8),
                            Text(
                              formattedDate, // Formatted date
                              style: TextStyle(fontSize: 13), // Adjust font size
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 8), // Add padding to the bottom
                        child: Row(
                          children: [
                            Icon(Icons.access_time), // Time icon
                            SizedBox(width: 8),
                            Text(
                              formattedTime, // Formatted time
                              style: TextStyle(fontSize: 13), // Adjust font size
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaveDetailsPage(leave: leave),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                          Size(double.infinity, 50)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF004AAD)), // Set background color
                    ),
                    child: Text('Details'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadLeaveData() async {
    try {
      final String? username = await _controller.getUsername();
      if (username != null && username.isNotEmpty) {
        final List<dynamic> data =
        await _controller.fetchLeaveData(username);
        setState(() {
          leaveData = data;
        });
      } else {
        print('Username not found');
      }
    } catch (error) {
      print(error);
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
      case 'Cancelled':
        return Colors.orange.shade900;
      default:
        return Colors.blue.shade900;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Status'),
          content: DropdownButton<String>(
            value: selectedStatus,
            onChanged: (String? newValue) {
              setState(() {
                selectedStatus = newValue!;
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            items: <String>['All', 'Pending', 'Approved', 'Rejected', 'Cancelled']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}