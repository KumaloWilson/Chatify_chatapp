import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/app/utils/animation/styles/app_colors.dart';
import 'package:enefty_icons/enefty_icons.dart';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  final String userId;
  final String userName;
  final String statusText;

  const DisplayImageScreen({
    required this.imagePath,
    required this.userId,
    required this.userName,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height * 100,
            width: size.width,
            color: Colors.black,
            child: Hero(
              tag: '',
              child: Image.file(File(imagePath)),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.primaryHighContrast,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(CupertinoIcons.back),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.primaryHighContrast,
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('status')
                    .doc(userId)
                    .set({
                  "uid": userId,
                  'image': imagePath,
                  'name': userName,
                });
                FirebaseFirestore.instance
                    .collection('status')
                    .doc(userId)
                    .collection('status')
                    .doc()
                    .set({
                  "Data": statusText,
                  'timestamp': DateTime.now().toUtc(),
                });
                Future.delayed(const Duration(minutes: 30), () {
                  FirebaseFirestore.instance
                      .collection('status')
                      .doc(userId)
                      .collection('status')
                      .where('timestamp',
                          isLessThan: DateTime.now()
                              .subtract(const Duration(minutes: 30)))
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      doc.reference.delete();
                    });
                  });
                });
                Navigator.pop(context);
              },
              child: Icon(EneftyIcons.send_2_outline),
            ),
          ),
        ],
      ),
    );
  }
}
