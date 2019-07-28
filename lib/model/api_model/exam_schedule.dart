import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';

class ExamSchedule {
  Account account;

  Exam exam;

  ExamSchedule({@required this.account, @required this.exam})
      : assert(account != null),
        assert(exam != null);

  Map<String, String> toMap() {
    return account.toMap()..addAll(exam.toMap());
  }
}
