part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class TabChangeEvent extends HomeEvent {
  final int tabIndex;
  TabChangeEvent({
    required this.tabIndex,
  });
}
