import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:thi_trac_nghiem/api/post/post_favorite_question.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/api_model/favorite.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';
import 'package:toast/toast.dart';

class QuestionItem extends StatefulWidget {
  final Question _question;
  final int _curIndex;

  const QuestionItem(this._question, this._curIndex);

  @override
  State<StatefulWidget> createState() {
    return _QuestionState();
  }
}

class _QuestionState extends State<QuestionItem> {
  static const TextStyle _questionStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const _textStyle = TextStyle(
    fontSize: 13.0,
  );

  @override
  Widget build(BuildContext context) {
    final question = widget._question;

    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              decoration: BoxDecoration(color: UIData.primaryColor),
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: Text(
                            '${widget._curIndex + 1}',
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white70,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: question.isFavorite
                                  ? UIData.primarySwatch
                                  : Colors.black45,
                            ),
                            onPressed: () async {
                              final x = question.isFavorite;

                              setState(() {
                                question.isFavorite = !x;
                              });

                              final msg =
                                  'Đang ${!x
                                  ? 'thêm vào'
                                  : 'xóa khỏi'} danh sách yêu thích';
                              Toast.show(msg, context);

                              final bool isSuccess =
                              await PostFavoriteQuestion()
                                  .postExamSchedule(Favorite(
                                account: UserManagement().curAccount,
                                question: question,
                              ));

                              if (isSuccess) {
                                final msg =
                                    'Đã ${!x
                                    ? 'thêm vào'
                                    : 'xóa khỏi'} danh sách yêu thích';
                                Toast.show(msg, context);
                              } else {
                                setState(() {
                                  question.isFavorite = x;
                                });
                                Toast.show('Có lỗi xảy ra', context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Tooltip(
                        child: Text(
                          question.content,
                          style: _questionStyle,
                        ),
                        message: question.content,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _makeRadioButton(
                        index: 0,
                      ),
                      _makeRadioButton(
                        index: 1,
                      ),
                      _makeRadioButton(
                        index: 2,
                      ),
                      _makeRadioButton(
                        index: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _makeRadioButton({@required int index}) {
    final question = widget._question;
    return RadioListTile(
      title: Text(
        question.listDapAn[index],
        style: _textStyle,
        textAlign: TextAlign.left,
      ),
      value: question.listDapAn[index],
      groupValue: question.answerOfUser,
      onChanged: (x) => setState(() => question.answerOfUser = x),
    );
  }
}
