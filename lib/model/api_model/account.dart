class Account {
  String username;
  String password;
  bool isStudent;

  Account({
    this.username = '',
    this.password = '',
    this.isStudent = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          password == other.password &&
          isStudent == other.isStudent;

  @override
  int get hashCode =>
      username.hashCode ^ password.hashCode ^ isStudent.hashCode;

  @override
  String toString() {
    return 'Account{_username: $username, _password: $password, _isStudent: $isStudent}';
  }
}

class User {
  String status;
  String role;
  String maso;
  String name;

  User({this.status, this.role, this.maso, this.name});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    role = json['role'];
    maso = json['maso'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['role'] = this.role;
    data['maso'] = this.maso;
    data['name'] = this.name;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          role == other.role &&
          maso == other.maso &&
          name == other.name;

  @override
  int get hashCode =>
      status.hashCode ^ role.hashCode ^ maso.hashCode ^ name.hashCode;
}
