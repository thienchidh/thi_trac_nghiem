import 'package:thi_trac_nghiem/api/config/config_api.dart';

class Account {
  String username;
  String password;
  bool isStudent;

  Account({
    this.username = '',
    this.password = '',
    this.isStudent = true,
  });

  Map<String, String> toMap() {
    return {
      'userName': username,
      'pass': password,
    };
  }

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
  String lop;
  UserType userType;

  static const String TEACHER = 'giangvien';
  static const String STUDENT = 'sinhvien';

  User();

  User.fromJson(Map<String, dynamic> json) {
    status = json[STATUS];
    role = json['role'];
    maso = json['maso'];
    name = json['name'];
    lop = json['lop'];
    userType = (role == TEACHER) ? UserType.teacher : UserType.student;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[STATUS] = this.status;
    data['role'] = this.role;
    data['maso'] = this.maso;
    data['name'] = this.name;
    data['lop'] = this.lop;
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
              name == other.name &&
              lop == other.lop;

  @override
  int get hashCode =>
      status.hashCode ^
      role.hashCode ^
      maso.hashCode ^
      name.hashCode ^
      lop.hashCode;
}

enum UserType {
  student,
  teacher,
  both,
  none,
}
