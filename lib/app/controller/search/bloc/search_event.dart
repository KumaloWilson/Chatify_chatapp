part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class PerformSearchEvent extends SearchEvent {
  final String searchText;

  PerformSearchEvent(this.searchText);
}