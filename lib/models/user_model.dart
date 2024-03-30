class User {
  final String fullName;
  final String department;
  final String niwosID;

  User({required this.fullName, required this.department, required this.niwosID});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['FullName'],
      department: json['DepartmentName'],
      niwosID: json['Niwos_ID'],
    );
  }
}
