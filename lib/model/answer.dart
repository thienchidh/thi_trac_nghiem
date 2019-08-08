import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';

class StudentAnswer {
  Account account;
  Exam exam;
  List<Question> questions;

  StudentAnswer({this.account, this.exam, this.questions});

  Map<String, String> toMap() {
    List<List<String>> list = [];

    final int other = 4;

    for (int i = 0; i < other; i++) {
      list.add([]);
    }

    for (Question question in questions) {
      final indexOfAnswer = question.getIndexOfAnswer();
      if (indexOfAnswer >= 0 && indexOfAnswer < question.listDapAn.length) {
        list[indexOfAnswer].add(question.id);
      }
    }

    for (int i = 0; i < other; i++) {
      if (list[i].isEmpty) {
        list[i].add('null');
      }
    }

    final result = account.toMap()..addAll(exam.toMap());
    for (int i = 0; i < other; i++) {
      String key = _concat('dap_an_', 97 + i);
      result..addAll(_makeString(key, list[i]));
    }

    return result;
  }
}

String _concat(String x, int charCode) {
  return '$x${String.fromCharCode(charCode)}';
}

Map<String, String> _makeString(String key, List<String> list) {
  StringBuffer sb = StringBuffer();
  sb.writeAll(list, ';');
  return {key: sb.toString()};
}
