import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/controllers/profile_update_page_controller.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final ProfileController _controller = ProfileController();
  File? _selectedImage;
  File? _selectedSecurityImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('Update Profile'),
      ),
      body: Container(
        color: Colors.grey[350],
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Update Profile Image',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final file = await _controller.pickImage(ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            _selectedImage = file;
                          });
                        }
                      },
                      child: CustomPaint(
                        painter: DashedRectPainter(),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: _selectedImage != null
                                ? Image.file(
                              _selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Click to choose your image',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_selectedImage != null) {
                          bool uploaded = await _controller.uploadImage(_selectedImage!);
                          if (uploaded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Profile image uploaded successfully'),
                                backgroundColor: Colors.green[900],
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to upload profile image'),
                                backgroundColor: Colors.red[900],
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select an image to upload'),
                              backgroundColor: Colors.grey[900],
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                        backgroundColor: Color(0xFF004AAD),
                      ),
                      child: Text('Upload', style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Update Security Image',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final file = await _controller.pickSecurityImage(ImageSource.gallery);
                        if (file != null) {
                          setState(() {
                            _selectedSecurityImage = file;
                          });
                        }
                      },
                      child: CustomPaint(
                        painter: DashedRectPainter(),
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: _selectedSecurityImage != null
                                ? Image.file(
                              _selectedSecurityImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_library,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Click to choose your image',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_selectedSecurityImage != null) {
                          bool uploaded = await _controller.uploadSecurityImage(_selectedSecurityImage!);
                          if (uploaded) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Security image uploaded successfully'),
                                backgroundColor: Colors.green[900],
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to upload security image'),
                                backgroundColor: Colors.red[900],
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a security image to upload'),
                              backgroundColor: Colors.grey[900],
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                        backgroundColor: Color(0xFF004AAD),
                      ),
                      child: Text('Upload', style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Set the color of the dashed lines
      ..strokeWidth = 2 // Set the width of the dashed lines
      ..style = PaintingStyle.stroke;

    final double dashWidth = 5; // Define the width of each dash
    final double dashSpace = 5; // Define the space between dashes

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    double endX = size.width;
    while (endX > 0) {
      canvas.drawLine(
        Offset(endX, size.height),
        Offset(endX - dashWidth, size.height),
        paint,
      );
      endX -= dashWidth + dashSpace;
    }

    double endY = size.height;
    while (endY > 0) {
      canvas.drawLine(
        Offset(size.width, endY),
        Offset(size.width, endY - dashWidth),
        paint,
      );
      endY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}