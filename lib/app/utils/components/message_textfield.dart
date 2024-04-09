import 'package:chat_app/app/controller/chat/bloc/chat_bloc.dart';
import 'package:chat_app/app/utils/components/bottomsheet.dart';
import 'package:chat_app/app/utils/animation/styles/app_colors.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  MessageTextField(this.currentId, this.friendId);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  bool showEmojiPicker = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is BottomSheetSuccessState) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) =>
                bottomSheet(context, widget.currentId, widget.friendId),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsetsDirectional.only(
            top: 12,
            bottom: 12,
            start: 8,
            end: 8,
          ),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.white,
                    blurStyle: BlurStyle.solid,
                    spreadRadius: 8,
                    blurRadius: 8)
              ],
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Expanded(
              child: Column(
            children: [
              TextFormField(
                controller: controller,
                onChanged: (text) {
                  setState(() {}); // Update UI when text changes
                },
                minLines: 1,
                maxLines: 3,
                // style: TextStyle(color: Colors.white),
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Type Here... ",
                    hintStyle: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w400),
                    fillColor: AppColors.primaryColor,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 14),
                    filled: true,
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filled(
                            style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.transparent)),
                            onPressed: () {
                              setState(() {
                                showEmojiPicker = !showEmojiPicker;
                              });
                            },
                            icon: const Icon(Iconsax.emoji_happy,
                                color: Colors.white)),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                    suffixIcon: controller.text.isEmpty
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () {
                                    BlocProvider.of<ChatBloc>(context).add(
                                        CameraImagesSentEvent(
                                            currentId: widget.currentId,
                                            friendId: widget.friendId));
                                  },
                                  icon: const Icon(Iconsax.camera,
                                      color: Colors.white)),
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () {
                                    BlocProvider.of<ChatBloc>(context).add(
                                        GalleryImagesSentEvent(
                                            currentId: widget.currentId,
                                            friendId: widget.friendId));
                                  },
                                  icon: state is ChatLoading
                                      ? const SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Iconsax.image,
                                          color: Colors.white)),
                              IconButton.filled(
                                  style: const ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () {
                                    BlocProvider.of<ChatBloc>(context).add(
                                        LocationSentEvent(
                                            currentId: widget.currentId,
                                            friendId: widget.friendId));
                                  },
                                  icon: const Icon(Iconsax.location,
                                      color: Colors.white)),
                              // IconButton(
                              //     onPressed: () {
                              //       BlocProvider.of<ChatBloc>(context)
                              //           .add(BottomSheetEvent());
                              //     },
                              //     icon: const Icon(Ionicons.attach)),
                            ],
                          )
                        : TextButton(
                            onPressed: () async {
                              String message = controller.text;
                              controller.clear();
                              setState(() {});
                              if (message.isNotEmpty) {
                                BlocProvider.of<ChatBloc>(context).add(
                                    ChatShareEvent(
                                        currentId: widget.currentId,
                                        friendId: widget.friendId,
                                        message: message));
                              }
                            },
                            child: Text(
                              "Send",
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )),
                    border: InputBorder.none
                    // border: OutlineInputBorder(
                    // borderSide: const BorderSide(width: 0),
                    // gapPadding: 10,
                    // borderRadius: BorderRadius.circular(25))
                    ),
              ),
              showEmojiPicker
                  ? SizedBox(
                      height: 300,
                      child: EmojiPicker(
                        textEditingController: controller,
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          )),
        );
      },
    );
  }
}
