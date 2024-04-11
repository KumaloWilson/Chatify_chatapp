import 'package:chat_app/app/controller/status/bloc/status_bloc.dart';
import 'package:chat_app/app/utils/components/statusTextPage.dart';
import 'package:chat_app/app/utils/animation/styles/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:status_view/status_view.dart';
import '../statusView/statusview.dart';
import 'package:timeago/timeago.dart' as timeago;

class Status extends StatefulWidget {
  const Status({Key? key});

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  String? id;

  @override
  Widget build(BuildContext context) {
    String? image;
    User? user = FirebaseAuth.instance.currentUser;
    String name = '';
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<StatusBloc, StatusState>(
        builder: (context, state) {
          BlocProvider.of<StatusBloc>(context).add(IntialEvent());
          if (state is FetchState) {
            image = state.imageUrl;
            name = state.name;
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: 160,
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
                              width: 40,
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(4.0),
                            //   child: Container(
                            //     height: 40,
                            //     width: 40,
                            //     decoration: BoxDecoration(
                            //       color: Colors.black,
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: GestureDetector(
                            //       onTap: () => Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) => ShowImage(
                            //                 imageUrl: image!, message: ''),
                            //           )),
                            //       child: CircleAvatar(
                            //         backgroundImage: NetworkImage(
                            //             image!), // Use user's image URL
                            //         backgroundColor: Colors
                            //             .transparent, // Ensure transparent background
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const Spacer(),
                            Text(
                              "Stories",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 23,
                                  color: Colors.white),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StatusTextPage(
                                        image: image,
                                        name: name,
                                        id: id,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Iconsax.story,
                                    color: Colors.white)),
                            const SizedBox(
                              width: 8,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -MediaQuery.sizeOf(context).height / 4,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('status')
                                    .doc(user?.uid)
                                    .collection('status')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final docs = snapshot.data!.docs;
                                    if (docs.isNotEmpty) {
                                      final datas = docs.first;
                                      final date = datas['timestamp'];
                                      String formattedTime =
                                          timeago.format(date.toDate());
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StatusViewPage(id: user!.uid),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, top: 2, bottom: 10),
                                          child: Row(
                                            children: [
                                              StatusView(
                                                unSeenColor:
                                                    AppColors.primaryColor,
                                                seenColor: Colors.grey,
                                                radius: 29,
                                                centerImageUrl: image ?? '',
                                                numberOfStatus: docs.length,
                                              ),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    formattedTime,
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StatusTextPage(
                                            image: image,
                                            name: name,
                                            id: id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                              image ?? ''),
                                                      radius: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 2,
                                                right: -2,
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: Icon(
                                                    Iconsax.add_circle5,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 25,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Add Status",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "Tap to add status update",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 8),
                          child: Text(
                            'Recent Updates',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryDark),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('status')
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              final documents = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: documents.length,
                                itemBuilder: (context, index) {
                                  final data = documents[index];
                                  if (data.id != user?.uid) {
                                    return StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('status')
                                          .doc(data.id)
                                          .collection('status')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final docs = snapshot.data!.docs;
                                          final datas = docs.isNotEmpty
                                              ? docs.first
                                              : null;
                                          if (datas != null) {
                                            final date = datas['timestamp'];
                                            String formattedTime =
                                                timeago.format(date.toDate());
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        StatusViewPage(
                                                            id: data.id),
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12,
                                                    top: 2,
                                                    bottom: 16),
                                                child: Row(
                                                  children: [
                                                    StatusView(
                                                      unSeenColor: AppColors
                                                          .primaryColor,
                                                      seenColor: Colors.grey,
                                                      radius: 29,
                                                      centerImageUrl:
                                                          data['image'],
                                                      numberOfStatus:
                                                          docs.length,
                                                    ),
                                                    const SizedBox(width: 20),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(data['name'],
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            )),
                                                        Text(
                                                          formattedTime,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                        return Container();
                                      },
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
