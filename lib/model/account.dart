class Account {
  String _username;
  String _password;
  bool _isStudent;

  Account({
    username,
    password,
    isStudent,
  })  : _username = username != null ? username : '',
        _password = password != null ? password : '',
        _isStudent = isStudent != null ? isStudent : true;

  bool get isStudent => _isStudent;

  set isStudent(bool value) {
    _isStudent = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          _username == other._username &&
          _password == other._password &&
          _isStudent == other._isStudent;

  @override
  int get hashCode =>
      _username.hashCode ^ _password.hashCode ^ _isStudent.hashCode;

  @override
  String toString() {
    return 'Account{_username: $_username, _password: $_password, _isStudent: $_isStudent}';
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
