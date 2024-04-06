part of 'status_bloc.dart';

@immutable
sealed class StatusState {}

final class StatusInitial extends StatusState {}


class FetchState extends StatusState {
  final String name;
  final String imageUrl;
  final String email;

  FetchState({
    required this.email,
    required this.name,
    required this.imageUrl,
  });
}

class ColorPickState extends StatusState {}

// ignore: must_be_immutable
class ColorPickerState extends StatusState {
  Color color;
  ColorPickerState({required this.color});
}