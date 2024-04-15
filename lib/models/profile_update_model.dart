import 'dart:io';

class ProfileModel {
  File? imageFile;

  void setImageFile(File file) {
    imageFile = file;
  }

  File? getImageFile() {
    return imageFile;
  }
}
