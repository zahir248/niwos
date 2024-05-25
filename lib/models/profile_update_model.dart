import 'dart:io';

class ProfileModel {
  File? imageFile;
  File? securityImageFile; // New field for the security image file

  void setImageFile(File file) {
    imageFile = file;
  }

  File? getImageFile() {
    return imageFile;
  }

  // Method to set the security image file
  void setSecurityImageFile(File file) {
    securityImageFile = file;
  }

  // Method to get the security image file
  File? getSecurityImageFile() {
    return securityImageFile;
  }
}