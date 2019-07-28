import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/model/api_model/account.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';

class Favorite {
  Account account;
  Question question;
  int isFavorite;

  Favorite(
      {@required this.account,
      @required this.question,
      @required this.isFavorite})
      : assert(account != null),
        assert(question != null),
        assert(isFavorite != null);

  Map<String, String> toMap() {
    return account.toMap()
      ..addAll({
        'idQuestion': question.id,
        'isFavourite': '$isFavorite',
      });
  }
}
