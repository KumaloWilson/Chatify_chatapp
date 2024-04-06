// ignore_for_file: unnecessary_string_interpolations
import 'package:chat_app/app/controller/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

bottomSheet(BuildContext context, String currentId, String friendId) {
  return BlocListener<ChatBloc, ChatState>(
    listener: (context, state) {
      if (state is GalleryImageSentSuccessState) {
        Navigator.of(context).pop();
      }
    },
    child: Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            chatIcon(Ionicons.location_outline, "Location", () {
              BlocProvider.of<ChatBloc>(context).add(
                  LocationSentEvent(currentId: currentId, friendId: friendId));
            }),

            chatIcon(Ionicons.camera_outline, "Camera", () {
              BlocProvider.of<ChatBloc>(context).add(CameraImagesSentEvent(
                  currentId: currentId, friendId: friendId));
            }),

            chatIcon(Ionicons.images_outline, "Photo", () {
              BlocProvider.of<ChatBloc>(context).add(GalleryImagesSentEvent(
                  currentId: currentId, friendId: friendId));
            }),
            
          ],
        ),
      ),
    ),
  );
}

chatIcon(IconData icon, String title, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue[200],
          radius: 30,
          child: Icon(
            icon,
          ),
        ),
        Text("$title"),
      ],
    ),
  );
}
