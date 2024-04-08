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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 24, left: 18, right: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.transparent.withOpacity(0.4),
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
                  ),
                  title: Text(
                    username,
                    style: const TextStyle(color: Colors.amber, fontSize: 15),
                  ),
                  subtitle: const Text(
                    "4 hours ago",
                    style: TextStyle(fontSize: 15, color: Colors.amber),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
