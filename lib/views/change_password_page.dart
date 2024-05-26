import 'package:flutter/material.dart';

import '/controllers/change_password_page_controller.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ChangePasswordPageController _changePasswordPageController = ChangePasswordPageController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Change Password'),
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
                      'Change Password Form',
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildPasswordField(
                            'Old Password', _oldPasswordController,
                            _obscureOldPassword, (value) {
                          setState(() {
                            _obscureOldPassword = value;
                          });
                        }),
                        SizedBox(height: 10),
                        _buildPasswordField(
                            'New Password', _newPasswordController,
                            _obscureNewPassword, (value) {
                          setState(() {
                            _obscureNewPassword = value;
                          });
                        }),
                        SizedBox(height: 10),
                        _buildPasswordField(
                            'Confirm Password', _confirmPasswordController,
                            _obscureConfirmPassword, (value) {
                          setState(() {
                            _obscureConfirmPassword = value;
                          });
                        }),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              bool success = await _changePasswordPageController
                                  .changePassword(
                                context,
                                _oldPasswordController.text,
                                _newPasswordController.text,
                              );
                              if (success) {
                                Navigator.pop(context);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(165, 50),
                            backgroundColor: Color(0xFF004AAD),
                          ),
                          child: Text('Update Password'),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String labelText, TextEditingController controller,
      bool obscureText, Function(bool) onToggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              labelText,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (labelText !=
                'Name of Area') // Show asterisk for all fields except Name of Area
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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                onToggle(!obscureText);
              },
            ),
          ),
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $labelText';
            }
            if (labelText == 'Confirm Password' &&
                value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }
}