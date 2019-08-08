import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_event.dart';
import 'package:thi_trac_nghiem/logic/bloc/timer_state.dart';
import 'package:thi_trac_nghiem/logic/ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final int _duration;
  final void Function() _onFinished;

  StreamSubscription<int> _tickerSubscription;

  TimerBloc({isAutoStart = true,
    @required duration,
    @required Ticker ticker,
    @required void Function() onFinished})
      : assert(duration != null),
        assert(ticker != null),
        assert(onFinished != null),
        _ticker = ticker,
        _duration = duration,
        _onFinished = onFinished {
    if (isAutoStart) {
      dispatch(StartTimer(duration: _duration));
    }
  }

  @override
  TimerState get initialState => TimerReady(_duration);

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    super.onTransition(transition);
//    print(transition);
  }

  @override
  Stream<TimerState> mapEventToState(
    TimerEvent event,
  ) async* {
    if (event is StartTimer) {
      yield* _mapStartToState(event);
    } else if (event is PauseTimer) {
      yield* _mapPauseToState(event);
    } else if (event is ResumeTimer) {
      yield* _mapResumeToState(event);
    } else if (event is ResetTimer) {
      yield* _mapResetToState(event);
    } else if (event is Tick) {
      yield* _mapTickToState(event);
    }
  }

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }

  Stream<TimerState> _mapStartToState(StartTimer start) async* {
    yield TimerRunning(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: start.duration).listen(
      (duration) {
        dispatch(Tick(duration: duration));
      },
    );
  }

  Stream<TimerState> _mapPauseToState(PauseTimer pause) async* {
    final state = currentState;
    if (state is TimerRunning) {
      _tickerSubscription?.pause();
      yield TimerPaused(state.duration);
    }
  }

  Stream<TimerState> _mapResumeToState(ResumeTimer pause) async* {
    final state = currentState;
    if (state is TimerPaused) {
      _tickerSubscription?.resume();
      yield TimerRunning(state.duration);
    }
  }

  Stream<TimerState> _mapResetToState(ResetTimer reset) async* {
    _tickerSubscription?.cancel();
    yield TimerReady(_duration);
  }

  Stream<TimerState> _mapTickToState(Tick tick) async* {
    if (tick.duration > 0) {
      yield TimerRunning(tick.duration);
    } else {
      yield TimerFinished();
      _onFinished();
    }
  }
}
