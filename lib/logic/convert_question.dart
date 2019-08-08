import 'package:collection/collection.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';

class ConvertQuestion {
  void convertAnswerToDest(final ExamQuestions item) {
    final pattern = ';';

    final detailListQuestion = item.listCauHoiDetails;
    if (detailListQuestion == null) {
      return;
    }
    final List<List<String>> list = [];

    void _computeAndAddToList(String x) {
      if (x == null) {
        return;
      }
      return list.add(x.split(pattern)..sort());
    }

    _computeAndAddToList(item.dapAnA);
    _computeAndAddToList(item.dapAnB);
    _computeAndAddToList(item.dapAnC);
    _computeAndAddToList(item.dapAnD);

    for (int i = 0, length = detailListQuestion.length; i < length; i++) {
      final question = detailListQuestion[i];
      final idQuestion = question.id;
      for (int x = 0; x < question.listDapAn.length; x++) {
        int index = binarySearch<String>(list[x], idQuestion);
        if (index != -1) {
          question.answerOfUser = question.listDapAn[x];
        }
      }
    }
  }
}
