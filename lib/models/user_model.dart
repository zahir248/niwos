class Users {
  final String name;
  final String department;
  final String niwosID;

  Users({required this.name, required this.department, required this.niwosID});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      name: json['name'],
      department: json['DepartmentName'],
      niwosID: json['Niwos_ID'],
    );
  }
}
