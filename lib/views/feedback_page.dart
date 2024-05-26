import 'package:flutter/material.dart';

import '/controllers/feedback_page_controller.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController problemDescriptionController = TextEditingController();
  final TextEditingController featureAreaController = TextEditingController();
  final TextEditingController severityController = TextEditingController();
  final TextEditingController problemDetailsController = TextEditingController();
  final TextEditingController impactController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController additionalCommentsController = TextEditingController();

  final FeedbackController _controller = FeedbackController();

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    await _controller.getUsername();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF004AAD),
          title: Text('Feedback Form'),
        ),
        backgroundColor: Colors.grey[350],
        body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Card(
    elevation: 3,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Container(
    color: Color(0xFF004AAD),
    padding: EdgeInsets.all(16.0),
    child: Center(
    child: Text(
    'Feedback Form',
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    _buildInputField('Briefly describe the problem you encountered: ', problemDescriptionController, maxLines: 3),
    SizedBox(height: 10),
    _buildInputField('Which feature of the system does this problem relate to?', featureAreaController),
    SizedBox(height: 10),
    _buildInputField('How would you rate the severity of this problem?', severityController),
    SizedBox(height: 10),
    _buildInputField('Provide more details about the problem. Include any error messages, unexpected behaviors, or specific steps that led to the issue:', problemDetailsController, maxLines: 3),
    SizedBox(height: 10),
    _buildInputField('How did this problem impact your workflow or tasks?', impactController, maxLines: 3),
    SizedBox(height: 10),
    _buildInputField('How often does this problem occur?', frequencyController),
    SizedBox(height: 10),
    _buildInputField('Additional Comments or Suggestions for Improvement:', additionalCommentsController, maxLines: 3),
    SizedBox(height: 20),
    ElevatedButton(
    onPressed: () {
    _submitFeedback();
    },
    style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    minimumSize: Size(165, 50),
    backgroundColor: Color(0xFF004AAD),
    ),
    child: Text('Submit'),
    ),
    SizedBox(height: 20),
    ],
    ),
    ),
    ],
    ),
    ),
    ),
        )
    );
  }

  Widget _buildInputField(String labelText, TextEditingController controller, {int? maxLines}) {
    if (labelText == 'Which feature of the system does this problem relate to?') {
      // Dropdown for Feature Affected
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            onChanged: (value) {
              setState(() {
                controller.text = value!;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            items: [
              DropdownMenuItem(child: Text('User management'), value: 'User management'),
              DropdownMenuItem(child: Text('Attendance monitoring'), value: 'Attendance monitoring'),
              DropdownMenuItem(child: Text('Access control management'), value: 'Access control management'),
              DropdownMenuItem(child: Text('Payment monitoring'), value: 'Payment monitoring'),
            ],
          ),
        ],
      );
    } else if (labelText == 'How would you rate the severity of this problem?') {
      // Dropdown for Severity
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            onChanged: (value) {
              setState(() {
                controller.text = value!;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            items: [
              DropdownMenuItem(child: Text('Low'), value: 'Low'),
              DropdownMenuItem(child: Text('Medium'), value: 'Medium'),
              DropdownMenuItem(child: Text('High'), value: 'High'),
            ],
          ),
        ],
      );
    } else if (labelText == 'How often does this problem occur?') {
      // Dropdown for Frequency
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            onChanged: (value) {
              setState(() {
                controller.text = value!;
              });
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            items: [
              DropdownMenuItem(child: Text('Rarely'), value: 'Rarely'),
              DropdownMenuItem(child: Text('Occasionally'), value: 'Occasionally'),
              DropdownMenuItem(child: Text('Frequently'), value: 'Frequently'),
            ],
          ),
        ],
      );
    } else {
      // Regular TextFormField
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            maxLines: maxLines,
          ),
        ],
      );
    }
  }

  void _submitFeedback() {
    // Validate form fields
    if (!_validateFields()) {
      return;
    }

    // Retrieve form data
    final problemDescription = problemDescriptionController.text;
    final featureArea = featureAreaController.text;
    final severity = severityController.text;
    final problemDetails = problemDetailsController.text;
    final impact = impactController.text;
    final frequency = frequencyController.text;
    final additionalComments = additionalCommentsController.text;

    _controller.submitFeedback(
      problemDescription: problemDescription,
      featureArea: featureArea,
      severity: severity,
      problemDetails: problemDetails,
      impact: impact,
      frequency: frequency,
      additionalComments: additionalComments,
      onSubmitResult: (bool isSuccess) {
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Feedback submitted successfully'),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green[900],
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error submitting feedback'),
              backgroundColor: Colors.red[900],
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }

  bool _validateFields() {
    if (problemDescriptionController.text.isEmpty ||
        featureAreaController.text.isEmpty ||
        severityController.text.isEmpty ||
        problemDetailsController.text.isEmpty ||
        impactController.text.isEmpty ||
        frequencyController.text.isEmpty ||
        additionalCommentsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.grey[900],
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
    return true;
  }
}