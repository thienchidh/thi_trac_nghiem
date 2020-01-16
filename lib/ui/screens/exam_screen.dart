import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/api/config/config_api.dart';
import 'package:thi_trac_nghiem/api/data_source/doing_exam_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/api/post/submit_answer.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/logic/convert_question.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/answer.dart';
import 'package:thi_trac_nghiem/model/api_model/exam_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
import 'package:thi_trac_nghiem/model/api_model/list_students.dart';
import 'package:thi_trac_nghiem/ui/screens/base_screen_state.dart';
import 'package:thi_trac_nghiem/ui/screens/submit_answer_screen.dart';
import 'package:thi_trac_nghiem/ui/widget/action_timer.dart';
import 'package:thi_trac_nghiem/ui/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/ui/widget/current_questions_drawer.dart';
import 'package:thi_trac_nghiem/ui/widget/error_item.dart';
import 'package:thi_trac_nghiem/ui/widget/load_more_item.dart';
import 'package:thi_trac_nghiem/ui/widget/question_item.dart';
import 'package:thi_trac_nghiem/ui/widget/timer_widget.dart';
import 'package:thi_trac_nghiem/utils/dialog_ultis.dart';
import 'package:thi_trac_nghiem/utils/ui_data.dart';
import 'package:toast/toast.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends BaseScreenState<ExamQuestions> {
  final _controller = PageController(keepPage: true);

  final List<Question> _questions;

  _ExamScreenState()
      : _questions = List<Question>(),
        super();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: LoadMoreItem(
          isVisible: true,
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: BlocProvider(
          builder: (context) {
            final exam = UserManagement().curExamDoing;

            final timeEnd = serverDateFormat.parse(exam.thoiGianKetThuc);
            final curTime = serverDateFormat.parse(exam.timeserver);

            int duration = 0;
            if (exam.status == Exam.RUNNING) {
              duration += timeEnd.difference(curTime).inSeconds;
            }
            duration = max(duration, 0);

            return TimerBloc(
              ticker: Ticker(),
              onFinished: () => finishExam(),
              duration: duration,
            );
          },
          child: TimerWidget(
            actions: ActionsTimerRunningExam(),
          ),
        ),
      ),
      drawer: CommonDrawer(),
      endDrawer: CurrentQuestionsDrawer(
        items: _questions,
        onSelectItem: jumpToPage,
        onSubmit: () => submitAnswer(),
        onRandom: () => randomAnswer(),
      ),
      body: StreamBuilder<DataListState<ExamQuestions>>(
        stream: bloc.dataList,
        builder: (BuildContext context,
            AsyncSnapshot<DataListState<ExamQuestions>> snapshot) {
          if (snapshot.hasError) {
            return ErrorItem(
              onClick: () => refresh(),
            );
          }

          if (!snapshot.hasData) {
            return LoadMoreItem(isVisible: true);
          }

          return buildPage(snapshot);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildPage(AsyncSnapshot<DataListState<ExamQuestions>> snapshot) {
    final List<ExamQuestions> listData = []..addAll(snapshot.data.listData);

    if (listData.isEmpty) {
      listData.add(ExamQuestions(listCauHoiDetails: []));
    }

    final ExamQuestions data = listData.first;
    final bool isLoading = snapshot.data.isLoading;
    final Object error = snapshot.data.error;

    ConvertQuestion().convertAnswerToDest(data);
    _questions.clear();
    _questions.addAll(data.listCauHoiDetails);

    return WillPopScope(
      onWillPop: () => DialogUltis().showAlertDialog(context),
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: _questions.length + 1,
        itemBuilder: (context, index) {
          if (index < _questions.length) {
            if (_questions.isNotEmpty) {
              if (index % 5 == 0) {
                saveAnswer();
              }
            }
            return QuestionItem(_questions[index], index);
          }

          if (_questions.isNotEmpty) {
            saveAnswer();
            return SubmitScreen(
              onSubmit: () => submitAnswer(),
            );
          }

          if (error != null) {
            return ErrorItem(
              onClick: () => refresh(),
            );
          }
          return LoadMoreItem(
            isVisible: isLoading,
          );
        },
      ),
    );
  }

  Future<void> jumpToPage(int index) async {
    final scaffoldState = scaffoldKey.currentState;

    final isDrawerOpen = scaffoldState.isDrawerOpen;
    if (isDrawerOpen) {
      Navigator.pop(context);
    }
    final isEndDrawerOpen = scaffoldState.isEndDrawerOpen;
    if (isEndDrawerOpen) {
      Navigator.pop(context);
    }

    _controller.jumpToPage(index);
  }

  Future<bool> saveAnswer() async {
    return await SubmitAnswer().submitAnswer(
      StudentAnswer(
        account: UserManagement().curAccount,
        exam: UserManagement().curExamDoing,
        questions: _questions,
      ),
      isOnlySave: true,
    );
  }

  bool _checkIsMarkAll() {
    for (final question in _questions) {
      if (question.answerOfUser == Question.undefinedAnswer) {
        return false;
      }
    }
    return true;
  }

  Future<void> submitAnswer() async {
    if (!_checkIsMarkAll()) {
      bool isOk = await DialogUltis().showAlertDialog(
        context,
        title: 'Bạn chưa trả lời hết các câu hỏi',
        content: UIData.RANDOM_DIALOG_TEXT,
      );

      if (isOk) {
        randomAnswer();
      } else {
        Toast.show(
            'Bạn phải trả lời tất cả câu hỏi mới được nộp bài.', context);
        return;
      }
    }

    bool isOk = await DialogUltis().showAlertDialog(
      context,
      title: UIData.CONFIRM,
      content: UIData.SUBMIT_EXAM,
    );

    if (!isOk) {
      return;
    }

    await finishExam();
  }

  Future<void> finishExam() async {
    print('_ExamScreenState.finishExam');
    try {
      final answer = StudentAnswer(
        account: UserManagement().curAccount,
        exam: UserManagement().curExamDoing,
        questions: _questions,
      );

      final bool submitAnswer = await SubmitAnswer().submitAnswer(answer);

      if (!submitAnswer) {
        Toast.show('Nộp bài không thành công!', context);
        return;
      }
      Toast.show(
        'Đã nộp bài, bạn sẽ được đưa về trang chủ, khi kỳ thi kết thúc, bạn có thể xem điểm ở mục lịch sử',
        context,
        duration: 5,
      );

      UserManagement().curExamDoing = null;

      Navigator.popUntil(
        context,
        ModalRoute.withName('/${UIData.HOME_ROUTE_NAME}'),
      );
    } catch (e) {
      Toast.show(UIData.ERROR_OCCURRED, context);
    }
  }

  @override
  List<String> buildDataSourceParameter() =>
      [UserManagement().curExamDoing.maLoaiKt, UserManagement().curUser.maso];

  @override
  IDataSource<ExamQuestions> initDataSource() => DoingExamDataSource();

  Future<void> randomAnswer() async {
    final random = Random();
    for (final question in _questions) {
      if (question.answerOfUser == Question.undefinedAnswer) {
        final listDapAn = question.listDapAn;
        question.answerOfUser = listDapAn[random.nextInt(listDapAn.length)];
      }
    }
    Toast.show('Đã chọn ngẫu nhiên những câu bạn chưa làm!', context);
    await jumpToPage(_questions.length); // we have (_questions.length+1) page
  }
}
