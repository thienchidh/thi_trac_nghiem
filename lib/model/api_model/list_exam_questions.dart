import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';

class ListExamQuestions {
  String nextId;
  List<ExamQuestions> listData;

  ListExamQuestions({this.nextId, this.listData});

  ListExamQuestions.fromJson(Map<String, dynamic> json) {
    nextId = json['nextId'];
    if (json['ListData'] != null) {
      listData = List<ExamQuestions>();
      json['ListData'].forEach((v) {
        listData.add(ExamQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['nextId'] = this.nextId;
    if (this.listData != null) {
      data['ListData'] = this.listData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
