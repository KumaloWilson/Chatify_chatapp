// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ShowImage extends StatelessWidget {
  final String imageUrl;
  final String message;

  const ShowImage({
    Key? key,
    required this.imageUrl,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Hero(tag: message, child: Image.network(imageUrl)),
      ),
    );
  }
}
