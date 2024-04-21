import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import'/models/access_request_page_model.dart';
import '/main.dart';

class SubmitAccessRequestController {
  final AccessRequestModel model;

  SubmitAccessRequestController(this.model);

  bool isFormValid() {
    return model.nameOfArea != null &&
        model.startTimeDate.value != null &&
        model.endTimeDate.value != null;
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
      'name_of_area': model.nameOfArea!,
      'start_date_time': model.startTimeDate.value!.toString(),
      'end_date_time': model.endTimeDate.value!.toString(),
      'username': username!,
    };

    // Add reason to form data if it's not null
    if (model.reason != null) {
      formData['reason'] = model.reason!;
    }

    // Debug line: print form data
    print('Form data: $formData');

    // Send data to PHP server
    Uri url = Uri.parse('http://${AppConfig.baseIpAddress}${AppConfig.submitAccessRequestPath}');
    var response = await http.post(url, body: formData);

    // Debug line: print response status code and body
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    // Handle response
    if (response.statusCode == 200) {
      /// Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Access request submitted successfully'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green[900],
        ),
      );
      Navigator.of(context).pop();
    } else {
      // Error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit access request. Please try again.'),
          backgroundColor: Colors.red[900],
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<DateTime?> selectDateTime(BuildContext context, DateTime? pickedStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: pickedStartDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: pickedStartDate != null ? TimeOfDay.fromDateTime(pickedStartDate) : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Check if pickedDateTime is same as or before pickedStartDate
        if (pickedStartDate != null && pickedDateTime.isBefore(pickedStartDate) || pickedDateTime == pickedStartDate) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid End Date and Time'),
              backgroundColor: Colors.red[900],
              duration: Duration(seconds: 3),
            ),
          );
          return null; // Return null to indicate validation failure
        }
        return pickedDateTime;
      }
    }
  }
}