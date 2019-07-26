import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerState extends Equatable {
  final int duration;

  TimerState(this.duration, [List props = const []])
      : super([duration]..addAll(props));
}

class TimerReady extends TimerState {
  TimerReady(int duration) : super(duration);

  @override
  String toString() => 'Ready { duration: $duration }';
}

class TimerPaused extends TimerState {
  TimerPaused(int duration) : super(duration);

  @override
  String toString() => 'Paused { duration: $duration }';
}

class TimerRunning extends TimerState {
  TimerRunning(int duration) : super(duration);

  @override
  String toString() => 'Running { duration: $duration }';
}

class TimerFinished extends TimerState {
  TimerFinished() : super(0);

  @override
  String toString() => 'Finished';
}
