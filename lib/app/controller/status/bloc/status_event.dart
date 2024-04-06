part of 'status_bloc.dart';

@immutable
sealed class StatusEvent {}

class IntialEvent extends StatusEvent {}

// ignore: must_be_immutable
class ColorPickerEvent extends StatusEvent{
  Color color;
  ColorPickerEvent({required this.color});
}

class ColorPick extends StatusEvent{}