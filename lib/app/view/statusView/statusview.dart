import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

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
            indicatorForegroundColor: Colors.grey,
            storyItems: List.generate(
              documents.length,
              (index) => StoryItem.text(
                shown: true,
                duration: const Duration(seconds: 3),
                title: documents[index]['Data'],
                textStyle: const TextStyle(fontSize: 18),
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
    );
  }
}
