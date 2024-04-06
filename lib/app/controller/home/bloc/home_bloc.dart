// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial(tabIndex: 0)) {
    on<HomeEvent>((event, emit) {
      if (event is TabChangeEvent) {
        emit(HomeInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
