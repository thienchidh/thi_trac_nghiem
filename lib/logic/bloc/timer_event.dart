import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  TimerEvent([List props = const []]) : super(props);
}

class StartTimer extends TimerEvent {
  final int duration;

  StartTimer({@required this.duration}) : super([duration]);

  @override
  String toString() => "Start { duration: $duration }";
}

class PauseTimer extends TimerEvent {
  @override
  String toString() => "Pause";
}

class ResumeTimer extends TimerEvent {
  @override
  String toString() => "Resume";
}

class ResetTimer extends TimerEvent {
  @override
  String toString() => "Reset";
}

class Tick extends TimerEvent {
  final int duration;

  Tick({@required this.duration}) : super([duration]);

  @override
  String toString() => "Tick { duration: $duration }";
}
