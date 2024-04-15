import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:enefty_icons/enefty_icons.dart';
import 'package:chat_app/app/utils/animation/styles/app_colors.dart';

class DisplayImageScreen extends StatefulWidget {
  final String imagePath;
  final String userId;
  final String userName;

  const DisplayImageScreen({
    required this.imagePath,
    required this.userId,
    required this.userName,
  });

  @override
  State<DisplayImageScreen> createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen> {
  bool isloading = false;
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
              child: Image.file(File(widget.imagePath)),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.primaryHighContrast,
              onPressed: () async {
                setState(() {
                  isloading = true;
                });
                String imageUrl = await uploadImageToStorage(widget.imagePath);

                FirebaseFirestore.instance
                    .collection('status')
                    .doc(widget.userId)
                    .set({
                  "uid": widget.userId,
                  'image': imageUrl,
                  'name': widget.userName,
                  'dataType': 'image',
                });

                FirebaseFirestore.instance
                    .collection('status')
                    .doc(widget.userId)
                    .collection('status')
                    .doc()
                    .set({
                  "Data": imageUrl,
                  'dataType': 'image',
                  'timestamp': DateTime.now().toUtc(),
                });

                Future.delayed(const Duration(hours: 24), () {
                  FirebaseFirestore.instance
                      .collection('status')
                      .doc(widget.userId)
                      .collection('status')
                      .where('timestamp',
                          isLessThan: DateTime.now()
                              .subtract(const Duration(hours: 24)))
                      .get()
                      .then((QuerySnapshot querySnapshot) {
                    querySnapshot.docs.forEach((doc) {
                      doc.reference.delete();
                    });
                  });
                });
                Navigator.pop(context);
              },
              child: isloading
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(EneftyIcons.send_2_outline),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> uploadImageToStorage(String imagePath) async {
    File file = File(imagePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('$fileName.jpg');

    firebase_storage.UploadTask task = ref.putFile(file);

    await task.whenComplete(() => null);

    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
}
