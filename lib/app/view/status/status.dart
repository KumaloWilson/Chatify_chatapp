import 'package:chat_app/app/controller/status/bloc/status_bloc.dart';
import 'package:chat_app/app/utils/components/statusTextPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:status_view/status_view.dart';
import '../statusView/statusview.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            const SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                    color: Colors.black, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(Iconsax.profile_circle, color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            Text(
              "Stories",
              style: GoogleFonts.poppins(
                fontSize: 22,
              ),
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
                icon: const Icon(Iconsax.story)),
            const SizedBox(
              width: 8,
            )
          ],
        ),
        body: BlocBuilder<StatusBloc, StatusState>(
          builder: (context, state) {
            BlocProvider.of<StatusBloc>(context).add(IntialEvent());
            if (state is FetchState) {
              image = state.imageUrl;
              name = state.name;
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 10),
                    child: Text(
                      "Status",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('status')
                        .doc(user?.uid) // Checking the current user's status
                        .collection('status')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final docs = snapshot.data!.docs;
                        if (docs.isNotEmpty) {
                          // User has a story
                          final datas = docs.first;
                          final date = datas['timestamp'].toDate();
                          String formattedTime =
                              DateFormat("hh:mm a").format(date);
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
                                    unSeenColor: Colors.green,
                                    seenColor: Colors.grey,
                                    radius: 28,
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
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        formattedTime,
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }
                      // User doesn't have a story
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
                              padding: const EdgeInsets.only(left: 12),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.transparent,
                                          shape: BoxShape.circle),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(image ?? ''),
                                          radius: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 2,
                                      right: -2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Iconsax.add_circle5,
                                          color: Colors.black,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      fontSize: 14, color: Colors.grey),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                    child: Text(
                      'Recent Updates',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
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
                            // Exclude the current user's story
                            if (data.id != user?.uid) {
                              id = data.id;
                              return StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('status')
                                    .doc(id)
                                    .collection('status')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final docs = snapshot.data!.docs;
                                    if (index < docs.length) {
                                      final datas = docs[index];
                                      final date = datas['timestamp'].toDate();
                                      String formattedTime =
                                          DateFormat("hh:mm a").format(date);
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StatusViewPage(
                                                      id: data['uid']),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, top: 2, bottom: 10),
                                          child: Row(
                                            children: [
                                              StatusView(
                                                unSeenColor: Colors.black,
                                                seenColor: Colors.grey,
                                                radius: 28,
                                                centerImageUrl: data['image'],
                                                numberOfStatus: docs.length,
                                              ),
                                              const SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(data['name'],
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
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
                                  return Container();
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
