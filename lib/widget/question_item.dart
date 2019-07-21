import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:thi_trac_nghiem/model/list_questions.dart';

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
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const _textStyle = TextStyle(
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperOne(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    child: Text("${widget._curIndex + 1}"),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      widget._question.content,
                      softWrap: true,
                      style: _questionStyle,
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
                      title: widget._question.dapAnA,
                      value: 'A',
                    ),
                    _makeRadioButton(
                      title: widget._question.dapAnB,
                      value: 'B',
                    ),
                    _makeRadioButton(
                      title: widget._question.dapAnC,
                      value: 'C',
                    ),
                    _makeRadioButton(
                      title: widget._question.dapAnD,
                      value: 'D',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _makeRadioButton({@required String title, @required String value}) {
    return RadioListTile(
      title: Text(
        title,
        style: _textStyle,
        textAlign: TextAlign.left,
      ),
      value: value,
      groupValue: widget._question.answerOfUser,
      onChanged: (x) => setState(() => widget._question.answerOfUser = x),
    );
  }
}
