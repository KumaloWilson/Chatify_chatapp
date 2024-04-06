import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  StatusBloc() : super(StatusInitial()) {
    on<IntialEvent>((event, emit) async {
      User? user = FirebaseAuth.instance.currentUser;
      QuerySnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection("Users")
          .where("uid", isEqualTo: user!.uid)
          .get();
      if (userData.docs.isNotEmpty) {
        final email = userData.docs.last.get('email');
        final name = userData.docs.last.get('name');
        final imageUrl = userData.docs.last.get('image');

        emit(FetchState(
          name: name,
          imageUrl: imageUrl,
          email: email,
        ));
      }
    });

      on<ColorPick>((event, emit) {
      emit(ColorPickState());
    });
    on<ColorPickerEvent>((event, emit) {
      emit(ColorPickerState(color: event.color));
    });
  }
}
