import 'dart:math';

import 'package:meta/meta.dart';

class DelayUltis {
  final int milliseconds;
  bool _isRunning;

  int _oldTime;
  int _newTime;

  DelayUltis({@required this.milliseconds})
      : assert(milliseconds != null),
        _isRunning = false;

  void start() {
    assert(!_isRunning);

    _isRunning = true;
    _oldTime = DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> finish() async {
    _newTime = DateTime.now().millisecondsSinceEpoch;

    await Future.delayed(
      Duration(
        milliseconds: max(0, _newTime - _oldTime + milliseconds),
      ),
    );

    _isRunning = false;
  }
}
