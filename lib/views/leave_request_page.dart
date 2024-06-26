import 'package:flutter/material.dart';

import'/controllers/leave_request_page_controller.dart';
import'/models/leave_request_page_model.dart';

class SubmitLeaveRequestPage extends StatefulWidget {
  @override
  _SubmitLeaveRequestPageState createState() => _SubmitLeaveRequestPageState();
}

class _SubmitLeaveRequestPageState extends State<SubmitLeaveRequestPage> {
  final LeaveRequestModel _model = LeaveRequestModel();
  late final SubmitLeaveRequestController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SubmitLeaveRequestController(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Leave Request'),
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
                      'Leave Request Form',
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
                      _buildInputField('Type of Leave'),
                      SizedBox(height: 10),
                      _buildDateField('Start Date', _model.startDate.value),
                      SizedBox(height: 10),
                      _buildDateField('End Date', _model.endDate.value),
                      SizedBox(height: 10),
                      _buildInputField('Reason', maxLines: 3),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _controller.submitForm(context);
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
      ),
    );
  }

  Widget _buildInputField(String labelText, {int? maxLines}) {
    bool isTypeOfLeave = labelText == 'Type of Leave';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isTypeOfLeave)
              Text(
                ' *',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        SizedBox(height: 5),
        if (labelText == 'Type of Leave')
          DropdownButtonFormField<String>(
            value: _model.typeOfLeave,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            items: <String>['Sick', 'Vacation', 'Personal', 'Maternity']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _model.typeOfLeave = newValue;
              });
            },
          ),
        if (labelText != 'Type of Leave')
          TextFormField(
            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
              // hintText: 'Please enter reason', // Add hint text
            ),
            maxLines: maxLines,
            onChanged: (value) {
              _model.reason = value; // Update the reason field in the model
            },
          ),
      ],
    );
  }

  Widget _buildDateField(String labelText, DateTime? selectedDate) {
    bool isStartDate = labelText == 'Start Date';
    bool isEndDate = labelText == 'End Date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isStartDate || isEndDate)
              Text(
                ' *',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: () {
            _controller.selectDate(context, isStartDate);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ValueListenableBuilder<DateTime?>(
                  valueListenable: isStartDate
                      ? _model.startDate
                      : _model.endDate,
                  builder: (context, value, _) {
                    return Text(
                      value != null
                          ? "${value.toLocal()}".split(' ')[0]
                          : '',
                      style: TextStyle(color: Colors.grey[800]),
                    );
                  },
                ),
                Theme(
                  data: ThemeData(
                    iconTheme: IconThemeData(
                      color: Color(0xFF004AAD),
                    ),
                  ),
                  child: Icon(Icons.calendar_month),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}