part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  final int  tabIndex;

  const HomeState({required this.tabIndex});
}

final class HomeInitial extends HomeState {
  const HomeInitial({required super.tabIndex});
}
