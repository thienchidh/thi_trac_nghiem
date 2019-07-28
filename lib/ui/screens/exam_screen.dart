import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/api/data_source/i_data_source.dart';
import 'package:thi_trac_nghiem/api/data_source/question_exam_data_source.dart';
import 'package:thi_trac_nghiem/api/post/submit_answer.dart';
import 'package:thi_trac_nghiem/logic/bloc/data_bloc.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';
import 'package:thi_trac_nghiem/logic/user_management.dart';
import 'package:thi_trac_nghiem/model/answer.dart';
import 'package:thi_trac_nghiem/model/api_model/list_questions.dart';
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

class _ExamScreenState extends BaseScreenState<Question> {
  final _controller = PageController();

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
            return TimerBloc(
              ticker: Ticker(),
              voidCallbackOnFinished: () => submitAnswer(),
              duration: 100,
            );
          },
          child: TimerWidget(
            actions: ActionsTimerRunningExam(),
          ),
        ),
      ),
      drawer: CommonDrawer(),
      endDrawer: CurrentQuestionsDrawer(
        questions: _questions,
        onSelectQuestionCallBack: jumpToPage,
        onSubmitCallback: () => submitAnswer(),
      ),
      body: StreamBuilder<DataListState<Question>>(
        stream: bloc.dataList,
        builder: (BuildContext context,
            AsyncSnapshot<DataListState<Question>> snapshot) {
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

  Widget buildPage(AsyncSnapshot<DataListState<Question>> snapshot) {
    final UnmodifiableListView<Question> data = snapshot.data.listData;
    final bool isLoading = snapshot.data.isLoading;
    final Object error = snapshot.data.error;

    _questions.clear();
    _questions.addAll(data);

    return WillPopScope(
      onWillPop: () async {
        final bool isClose = await DialogUltis().showAlertDialog(context);
        if (isClose) {
          UserManagement().curExam = null;
        }
        return isClose;
      },
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index < data.length) {
            return QuestionItem(data[index], index);
          }

          if (data.isNotEmpty) {
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

  Future<void> jumpToPage(index) async {
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

  Future<void> submitAnswer() async {
    try {
      setState(() {
        isLoading = true;
      });

      await jumpToPage(_questions.length); // we have (_questions.length+1) page
      final answer = StudentAnswer(
        account: UserManagement().curAccount,
        exam: UserManagement().curExam,
        questions: _questions,
      );

      final bool submitAnswer = await SubmitAnswer().submitAnswer(answer);

      if (!submitAnswer) {
        Toast.show('Nộp bài Không thành công!', context);
        return;
      }
      Toast.show('Đã nộp bài', context);

      UserManagement().curExam = null;
      await Navigator.pushReplacementNamed(
        context,
        '/${UIData.FINISHED_ROUTE_NAME}',
        arguments: _questions,
      );
    } catch (e) {
      Toast.show('Có lỗi xảy ra!', context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  List<String> buildDataSourceParameter() =>
      [UserManagement().curUser.maso, UserManagement().curExam.maLoaiKt];

  @override
  DataSource<Question> initDataSource() => QuestionExamDataSource();
}
