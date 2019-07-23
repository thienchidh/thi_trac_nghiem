import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';

abstract class IQuestionDataSource {
  Future<List<Question>> getQuestions({
    @required String keyWord,
    bool isFirstLoading,
  });
}
