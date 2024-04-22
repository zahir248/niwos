import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/models/leave_request_page_model.dart';
import '/main.dart';

class SubmitLeaveRequestController {
  final LeaveRequestModel model;

  SubmitLeaveRequestController(this.model);

  bool isFormValid() {
    return model.typeOfLeave != null &&
        model.startDate.value != null &&
        model.endDate.value != null;
  }

  Future<void> submitForm(BuildContext context) async {
    if (!isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all required fields'),
          backgroundColor: Colors.grey[900],
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Retrieve username from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    // Prepare form data
    Map<String, dynamic> formData = {
      'type_of_leave': model.typeOfLeave!,
      'start_date': model.startDate.value!.toString(),
      'end_date': model.endDate.value!.toString(),
      'username': username!,
    };

    // Add reason to form data if it's not null
    if (model.reason != null) {
      formData['reason'] = model.reason!;
    }

    // Debug line: print form data
    print('Form data: $formData');

    // Send data to PHP server
    Uri url = Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.submitLeaveRequestPath}');
    var response = await http.post(url, body: formData);

    // Handle response
    if (response.statusCode == 200) {
      /// Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Leave request submitted successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green[900],
        ),
      );
      Navigator.of(context).pop();
    } else {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit leave request. Please try again.'),
          backgroundColor: Colors.red[900],
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void selectDate(BuildContext context, bool isStartDate) async {
    // Present date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? model.startDate.value ?? DateTime.now() : model.endDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    // Check if the picked date is not null and if it's an end date
    if (pickedDate != null && !isStartDate) {
      // Check if the picked end date is before the start date
      if (model.startDate.value != null && pickedDate.isBefore(model.startDate.value!)) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid End Date'),
            backgroundColor: Colors.red[900],
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // Update the end date if it's valid
        model.endDate.value = pickedDate;
      }
    } else if (pickedDate != null) {
      // Update the start date if it's valid
      model.startDate.value = pickedDate;
    }
  }
}
