// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: sort_child_properties_last, avoid_unnecessary_containers, unnecessary_overrides

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/app/utils/components/skelton.dart';
import 'package:chat_app/app/utils/animation/styles/app_colors.dart';
import 'package:chat_app/app/utils/animation/widgets/scalefade_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/app/controller/chat/bloc/chat_bloc.dart';
import 'package:chat_app/app/view/chatScreen/chatScreen.dart';
import 'package:chat_app/app/view/search/Search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  User? user = FirebaseAuth.instance.currentUser;
  String? lastMessageTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is NavigatedSearchPageDoneState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ));
        } else if (state is ChattedUserDeletedState) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf0f8ff),
        body: Stack(
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  constraints.maxHeight < 720
                      ? Positioned(
                          top: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.9,
                            width: MediaQuery.sizeOf(context).width,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor,
                                  blurStyle: BlurStyle.outer,
                                  blurRadius: 1,
                                )
                              ],
                              border: Border.all(color: AppColors.primaryColor),
                              color: AppColors.primaryColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Iconsax.menu5,
                                          color: Colors.white,
                                        )),
                                    const Spacer(),
                                    Text(
                                      "Messages",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Iconsax.notification,
                                          color: Colors.white,
                                        )),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.sizeOf(context).height,
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor,
                                blurStyle: BlurStyle.outer,
                                blurRadius: 1,
                              )
                            ],
                            border: Border.all(color: AppColors.primaryColor),
                            color: AppColors.primaryColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Iconsax.menu5,
                                        color: Colors.white,
                                      )),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Iconsax.notification,
                                        color: Colors.white,
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 40, top: 0, bottom: 10),
                                child: Text(
                                  "Messages",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
            Positioned(
              bottom: -height / 4,
              left: 0,
              right: 0,
              child: Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user!.uid)
                        .collection("messages")
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length < 1) {
                          return Center(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Text(
                                  "Stay Connected with your friends 👋",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 8),
                                child: Text(
                                  "Start your journey of connection. Build friendships,       share moments Stay connected with your friends. 🌟",
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ));
                        }
                        return ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            color: AppColors.primaryColor,
                            thickness: 0.1,
                          ),
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            var friendId = snapshot.data.docs[index].id;
                            var lastMsg = snapshot.data.docs[index]['last_msg'];
                            return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(friendId)
                                  .get(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  var friend = snapshot.data;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 6, left: 6, right: 6),
                                    child: ScaleFadeAnimation(
                                      delay: index.toDouble(),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(.0),
                                            width: 0.5,
                                          ),
                                          // borderRadius:
                                          //     BorderRadius.circular(30),
                                        ),
                                        child: ListTile(
                                          onLongPress: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                    'Delete Chat',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 20),
                                                  ),
                                                  content: Text(
                                                    'Are you sure you want to delete this Chat?',
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'Cancel',
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        BlocProvider.of<ChatBloc>(
                                                                context)
                                                            .add(ChattedFriendDeleteEvent(
                                                                currentUid:
                                                                    user!.uid,
                                                                friendId:
                                                                    friendId));
                                                      },
                                                      child: Text(
                                                        'Delete',
                                                        style: GoogleFonts
                                                            .poppins(),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          leading: SizedBox(
                                            width: 60,
                                            height: 70,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    width: 70,
                                                    height: 70,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: friend['image'] !=
                                                            null
                                                        ? CachedNetworkImage(
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                friend['image'],
                                                            placeholder: (conteext,
                                                                    url) =>
                                                                CircularProgressIndicator(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              strokeWidth: 3,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    const Icon(
                                                              Icons.error,
                                                            ),
                                                            height: 70,
                                                          )
                                                        : const Center(
                                                            child: Icon(Iconsax
                                                                .profile),
                                                          ),
                                                  ),
                                                ),
                                                // Positioned(
                                                //   bottom: 2,
                                                //   right: 2,
                                                //   child: Container(
                                                //     height: 16,
                                                //     width: 16,
                                                //     decoration:
                                                //         const BoxDecoration(
                                                //             shape:
                                                //                 BoxShape.circle,
                                                //             color:
                                                //                 Colors.white),
                                                //     child: Padding(
                                                //       padding:
                                                //           const EdgeInsets.all(
                                                //               2.0),
                                                //       child: Container(
                                                //         height: 14,
                                                //         width: 14,
                                                //         decoration:
                                                //             const BoxDecoration(
                                                //                 shape: BoxShape
                                                //                     .circle,
                                                //                 color: Colors
                                                //                     .green),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                          title: Text(
                                            friend['name'],
                                            style: GoogleFonts.archivo(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Container(
                                            child: lastMsg == "photo"
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Icons.photo,
                                                        size: 20,
                                                        color:
                                                            AppColors.darkGrey,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'photo',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize: 13,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : lastMsg == "location"
                                                    ? Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            Ionicons.location,
                                                            size: 20,
                                                            color: AppColors
                                                                .darkGrey,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'location',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 13,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    : Text(
                                                        '$lastMsg',
                                                        style:
                                                            GoogleFonts.archivo(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                          ),
                                          trailing: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(user!.uid)
                                                .collection('messages')
                                                .doc(friendId)
                                                .collection('chats')
                                                .orderBy('date',
                                                    descending: true)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final docs =
                                                    snapshot.data!.docs;
                                                if (docs.isNotEmpty) {
                                                  final lastMessageDoc =
                                                      docs.first;
                                                  final currentTime =
                                                      lastMessageDoc['date'];
                                                  lastMessageTime =
                                                      timeago.format(
                                                          currentTime.toDate());
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        lastMessageTime!,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 10),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              }
                                              return const SizedBox();
                                            },
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                          friendId:
                                                              friend['uid'],
                                                          friendName:
                                                              friend['name'],
                                                          friendImage:
                                                              friend['image']),
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SkeltonLoadingIndicator();
                              },
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
              color: AppColors.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(100))),
          height: 70,
          width: 70,
          child: FloatingActionButton(
            elevation: 2,
            onPressed: () {
              BlocProvider.of<ChatBloc>(context)
                  .add(NavigateToSearchPageEvent());
            },
            child: const Icon(
              Iconsax.add,
              size: 35,
            ),
            backgroundColor: AppColors.primaryColor,
            shape: const CircleBorder(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
