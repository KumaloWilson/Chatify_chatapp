import 'dart:ui';

import 'package:chat_app/app/utils/animation/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class StatusViewPage extends StatelessWidget {
  const StatusViewPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('status')
            .doc(id)
            .collection('status')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          return StoryView(
            indicatorForegroundColor: AppColors.primaryColor,
            storyItems: List.generate(
              documents.length,
              (index) => StoryItem.text(
                shown: true,
                duration: const Duration(seconds: 3),
                title: documents[index]['Data'],
                textStyle: GoogleFonts.poppins(fontSize: 18),
                backgroundColor: Color(documents[index]['color']),
              ),
            ),
            onComplete: () {
              Navigator.pop(context);
            },
            controller: StoryController(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 24, left: 18, right: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            // color: Colors.transparent,
            color: Colors.transparent,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('status')
                  .doc(id)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;
                var username = userData['name'];
                var profileImageUrl = userData['image'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl),
                    radius: 25,
                  ),
                  title: Text(
                    username,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // subtitle: Text(
                  //   '4 hours',
                  //   style: GoogleFonts.poppins(fontSize: 12),
                  // ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
