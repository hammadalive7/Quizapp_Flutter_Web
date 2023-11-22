class UserModel {
  String name;
  String email;
  bool isAdmin;
  String password;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    this.isAdmin = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      password: map['password'] ?? "",
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
      'password': password,
    };
  }
}