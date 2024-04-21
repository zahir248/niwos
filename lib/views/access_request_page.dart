import 'package:flutter/material.dart';

import'/controllers/access_request_page_controller.dart';
import'/models/access_request_page_model.dart';

class SubmitAccessRequestPage extends StatefulWidget {
  @override
  _SubmitAccessRequestPageState createState() => _SubmitAccessRequestPageState();
}

class _SubmitAccessRequestPageState extends State<SubmitAccessRequestPage> {
  final AccessRequestModel _model = AccessRequestModel();
  late final SubmitAccessRequestController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SubmitAccessRequestController(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Access Request'),
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
                      'Access Request Form',
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
                      _buildInputField('Name of Area'),
                      SizedBox(height: 10),
                      _buildTimeDateField('Start Date and Time', _model.startTimeDate.value),
                      SizedBox(height: 10),
                      _buildTimeDateField('End Date and Time', _model.endTimeDate.value),
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
    bool isNameOfArea = labelText == 'Name of Area';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isNameOfArea)
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
        if (labelText == 'Name of Area')
          DropdownButtonFormField<String>(
            value: _model.nameOfArea,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            items: <String>['Meeting rooms', 'Training rooms']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _model.nameOfArea = newValue;
              });
            },
          ),
        if (labelText != 'Name of Area')
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

  Widget _buildTimeDateField(String labelText, DateTime? selectedDate) {
    bool isStartDateTime = labelText == 'Start Date and Time';
    bool isEndDateTime = labelText == 'End Date and Time';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              isStartDateTime ? 'Start Date and Time' : 'End Date and Time',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isStartDateTime || isEndDateTime)
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
          onTap: () async {
            DateTime? pickedDateTime = await _controller.selectDateTime(context, isStartDateTime ? null : _model.startTimeDate.value);
            if (pickedDateTime != null) {
              setState(() {
                if (isStartDateTime) {
                  _model.startTimeDate.value = pickedDateTime;
                } else {
                  _model.endTimeDate.value = pickedDateTime;
                }
              });
            }
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
                  valueListenable: isStartDateTime
                      ? _model.startTimeDate
                      : _model.endTimeDate,
                  builder: (context, value, _) {
                    return Text(
                      value != null
                          ? "${value.toLocal()}".split(' ')[0] +
                          " ${value.hour}:${value.minute}"
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
                  child: Icon(Icons.calendar_today),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}