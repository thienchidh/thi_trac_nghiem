import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thi_trac_nghiem/api/api_question_data_source.dart';
import 'package:thi_trac_nghiem/bloc/question_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_bloc.dart';
import 'package:thi_trac_nghiem/bloc/timer_event.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';
import 'package:thi_trac_nghiem/model/enums.dart';
import 'package:thi_trac_nghiem/screens/submit_answer_screen.dart';
import 'package:thi_trac_nghiem/screens/timer_screen.dart';
import 'package:thi_trac_nghiem/widget/common_drawer.dart';
import 'package:thi_trac_nghiem/widget/question_item.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  QuestionBloc _bloc;
  StreamSubscription<void> _subscriptionReachMaxItems;
  StreamSubscription<Object> _subscriptionError;

  final _controller = PageController();

  bool _isReachMaxItem = false;

  _ExamScreenState() {
    _bloc = QuestionBloc(QuestionDataSource());

    // listen error, reach max items
    _subscriptionReachMaxItems =
        _bloc.loadedAllQuestion.listen(_onReachMaxItem);
    _subscriptionError = _bloc.error.listen(_onError);

    _bloc.refresh();
  }

  @override
  void initState() {
    super.initState();
  }

  void _loadMore() {
    print('_bloc.loadMore.add(null)');
    _bloc.loadMore.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: BlocProvider(
          builder: (context) {
            TimerBloc timerBloc = TimerBloc(
              ticker: Ticker(),
              duration: 86400, // TODO example
            );
            timerBloc
                .dispatch(Start(duration: timerBloc.currentState.duration));
            return timerBloc;
          },
          child: TimerMini(),
        ),
      ),
      drawer: CommonDrawer(),
      endDrawer: CommonDrawer(),
      body: Container(
        child: StreamBuilder<QuestionListState>(
          stream: _bloc.questionList,
          builder: (BuildContext context,
              AsyncSnapshot<QuestionListState> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: const CircularProgressIndicator(),
              );
            }

            return _buildPage(snapshot);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    Future.wait([
      _bloc.dispose(),
      _subscriptionError.cancel(),
      _subscriptionReachMaxItems.cancel(),
    ]);

    super.dispose();
  }

  Future<void> _onReachMaxItem(void _) async {
    _isReachMaxItem = true;
    // show animation when loaded all data
    await _scaffoldKey.currentState
        ?.showSnackBar(
          SnackBar(
            content: Text('Hết rồi!'),
          ),
        )
        ?.closed;
  }

  Future<void> _onError(Object error) async {
    await _scaffoldKey.currentState
        ?.showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra, vui lòng thử lại sau!'),
          ),
        )
        ?.closed;
  }

  Widget _buildPage(AsyncSnapshot<QuestionListState> snapshot) {
    final data = snapshot.data.question;
    final isLoading = snapshot.data.isLoading;
    final error = snapshot.data.error;

    return PageView.builder(
      // Changes begin here
      controller: _controller,
      scrollDirection: Axis.vertical,
      itemCount: data.length + 1,
      itemBuilder: (context, index) {
        if (index < data.length) {
          return QuestionItem(data[index], index);
        }
        if (!_isReachMaxItem) {
          _loadMore(); // item in last index => load more data
        } else {
          // TODO check no answer, ...
          return SubmitScreen(
            data: data,
            typeExam: TypeExam.testTest,
          );
        }

        if (error != null) {
          return ListTile(
            title: Text(
              'Có lỗi xảy ra, click vào đây để thử lại!',
              style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.0),
            ),
            isThreeLine: false,
            leading: CircleAvatar(
              child: Text(':('),
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
            ),
            onTap: () {
              _loadMore();
            },
          );
        }
        return Visibility(
          visible: isLoading,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
