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
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    String? username = await _controller.getUsername();
    if (username != null) {
      setState(() {
        _usernameController.text = username;
      });
    }
  }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImageCard('Update Profile Image', _selectedImage,
                  _controller.pickImage, (file) {
                    setState(() {
                      _selectedImage = file;
                    });
                  }, _controller.uploadImage),
              SizedBox(height: 20),
              _buildImageCard('Update Security Image', _selectedSecurityImage,
                  _controller.pickSecurityImage, (file) {
                    setState(() {
                      _selectedSecurityImage = file;
                    });
                  }, _controller.uploadSecurityImage),
              SizedBox(height: 20),
              _buildUsernameCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String title, File? imageFile,
      Future<File?> Function(ImageSource) pickImageFunction,
      Function(File?) onImagePicked,
      Future<bool> Function(File) uploadFunction) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final file = await pickImageFunction(ImageSource.gallery);
                if (file != null) {
                  onImagePicked(file);
                }
              },
              child: CustomPaint(
                painter: DashedRectPainter(),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: imageFile != null
                        ? Image.file(
                      imageFile,
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
                if (imageFile != null) {
                  bool uploaded = await uploadFunction(imageFile);
                  if (uploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Image uploaded successfully'),
                        backgroundColor: Colors.green[900],
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to upload image'),
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
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 32),
                backgroundColor: Color(0xFF004AAD),
              ),
              child: Text('Upload', style: TextStyle(fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Update Username',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String newUsername = _usernameController.text;
                if (newUsername.isNotEmpty) {
                  bool updated = await _controller.updateUsername(newUsername);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Username updated successfully'),
                        backgroundColor: Colors.green[900],
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update username'),
                        backgroundColor: Colors.red[900],
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a username'),
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
                padding: const EdgeInsets.symmetric(
                    vertical: 15, horizontal: 32),
                backgroundColor: Color(0xFF004AAD),
              ),
              child: Text('Update', style: TextStyle(fontSize: 15)),
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