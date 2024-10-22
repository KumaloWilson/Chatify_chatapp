// ignore_for_file: use_key_in_widget_constructors

import 'package:chat_app/app/view/root/root.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';

class OnBoardScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      imageUrl: 'assets/images/chatapp.gif',
      title: "Chat with Emojis and GIFs!",
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 14,
      ),
      subTitleTextStyle: GoogleFonts.poppins(
        fontSize: 12,
      ),
      subTitle: "Ping! Chat on!",
    ),
    Introduction(
      imageUrl: 'assets/images/plane-unscreen.gif',
      title: "Connect and Spread Good Vibes!",
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 14,
      ),
      subTitleTextStyle: GoogleFonts.poppins(
        fontSize: 12,
      ),
      subTitle: "Tap, type, talk! Let's chat!",
    ),
    Introduction(
      imageUrl: 'assets/images/chat.gif',
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 14,
      ),
      subTitleTextStyle: GoogleFonts.poppins(
        fontSize: 12,
      ),
      title: "Welcome to Chatify!",
      subTitle: "Your secrets are safe with us. Chatify",
    ),
  ];

  OnBoardScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroScreenOnboarding(
        backgroudColor: Colors.white,
        introductionList: list,
        skipTextStyle: GoogleFonts.poppins(
          fontSize: 14,
        ),
        onTapSkipButton: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AuthenticationScreen(),
          ));
        },
      ),
    );
  }
}
