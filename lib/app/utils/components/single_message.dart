// ignore_for_file: unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'package:chat_app/app/utils/components/showimage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleMessage extends StatefulWidget {
  final type;
  final currentTime;
  final String message;
  final bool isMe;
  SingleMessage(
      {required this.message,
      required this.isMe,
      required this.currentTime,
      required this.type});

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  String? lastMessageTime;
  @override
  Widget build(BuildContext context) {
    lastMessageTime = timeago.format(widget.currentTime.toDate());

    var color = const Color(0xFF5B17FE);
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                widget.type == 'text'
                    ? Container(
                        padding: widget.isMe
                            ? const EdgeInsets.only(
                                top: 10, right: 14, left: 14, bottom: 10)
                            : const EdgeInsets.only(
                                top: 10, right: 14, left: 8, bottom: 4),
                        margin: const EdgeInsets.only(
                            top: 10, bottom: 2, left: 10, right: 10),
                        constraints: const BoxConstraints(maxWidth: 200),
                        decoration: BoxDecoration(
                            color: widget.isMe ? color : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.zero)),
                        child: Text(
                          widget.message,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: widget.isMe ? Colors.white : Colors.black),
                        ))
                    : Container(
                        child: widget.type == "link"
                            ? Container(
                                padding: widget.isMe
                                    ? const EdgeInsets.only(
                                        top: 10,
                                        right: 14,
                                        left: 14,
                                        bottom: 10)
                                    : const EdgeInsets.only(
                                        top: 10, right: 14, left: 8, bottom: 4),
                                margin: const EdgeInsets.only(
                                    top: 10, bottom: 2, left: 10, right: 10),
                                constraints:
                                    const BoxConstraints(maxWidth: 260),
                                decoration: BoxDecoration(
                                    color: widget.isMe
                                        ? const Color(0xFF5B17FE)
                                        // : Colors.blue.withOpacity(0.7),
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.zero)),
                                child: GestureDetector(
                                  onTap: () async {
                                    await launchUrl(
                                        Uri.parse('${widget.message}'));
                                  },
                                  child: Text(
                                    widget.message,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: widget.isMe
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(right: 14, top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShowImage(
                                                          message:
                                                              widget.message,
                                                          imageUrl:
                                                              widget.message),
                                                ));
                                          },
                                          child: Hero(
                                            tag: widget.message,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.42,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(30)),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          widget.message),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(right: 17, left: 17, top: 1),
                  child: Text(
                    lastMessageTime!,
                    style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
