import 'dart:typed_data'; // Import the typed_data library to use Uint8List

class UserProfile {
  final String fullName;
  final String positionName;
  final String niwosID;
  final DateTime startDate;
  final String email;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final String departmentName;
  final Uint8List? profileImage; // Modify to accept Uint8List

  UserProfile({
    required this.fullName,
    required this.positionName,
    required this.niwosID,
    required this.startDate,
    required this.email,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.departmentName,
    this.profileImage, // Update constructor
  });

  factory UserProfile.fromJson(Map<String, dynamic> json, Uint8List? profileImage) {
    return UserProfile(
      fullName: json['FullName'],
      positionName: json['PositionName'],
      niwosID: json['Niwos_ID'],
      startDate: DateTime.parse(json['StartDate']),
      email: json['Email'],
      dateOfBirth: DateTime.parse(json['DateOfBirth']),
      phoneNumber: json['PhoneNumber'],
      departmentName: json['DepartmentName'],
      profileImage: profileImage, // Assign decoded image data
    );
  }
}
