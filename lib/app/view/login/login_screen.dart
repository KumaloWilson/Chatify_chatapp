import 'package:chat_app/app/controller/auth/bloc/auth_bloc.dart';
import 'package:chat_app/app/utils/components/continue_with.dart';
import 'package:chat_app/app/utils/components/my_square_tile.dart';
import 'package:chat_app/app/utils/constants/app_theme.dart';
import 'package:chat_app/app/utils/constants/text_constants.dart';
import 'package:chat_app/app/utils/constants/validators.dart';
import 'package:chat_app/app/view/home/home.dart';
import 'package:chat_app/app/view/root/root.dart';
import 'package:chat_app/app/view/util/styles/app_colors.dart';
import 'package:chat_app/app/view/util/styles/fadeanimation.dart';
import 'package:chat_app/app/view/util/styles/text_field_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is RegisterPageNavigatedState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthenticationScreen(),
              ));
        } else if (state is LoggedInSuccessState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Logged in successfully!")));
        } else if (state is LoggedInErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is GoogleButtonState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox.fromSize(
            size: MediaQuery.sizeOf(context),
            child: Stack(
              children: [
                Positioned(
                  bottom: 30,
                  left: 30,
                  right: 30,
                  child: FadeInAnimation(
                    delay: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.whiteColor.withOpacity(.8),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Text(
                              'Log In',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryHighContrast,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: emailValidate,
                              controller: _emailController,
                              style: textFieldTextStyle(),
                              decoration: textFieldDecoration('Email'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: passwordValidate,
                              focusNode: FocusNode(
                                canRequestFocus: true,
                              ),
                              controller: _passController,
                              style: textFieldTextStyle(),
                              decoration: textFieldDecoration('Password'),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      TextConstants.forgot,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryHighContrast,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: AppColors.whiteColor,
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthBloc>(context).add(
                                        LoginButtonClickedEvent(
                                            email: _emailController.text,
                                            password: _passController.text));
                                  }

                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Text(
                                  "Sign In",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            continueWIth(context),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SquareTile(
                                  onTap: () {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(GoogleButtonClickedEvent());
                                  },
                                  child: Image.asset(
                                    "assets/images/google.png",
                                    height: 25,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                SquareTile(
                                  onTap: () async {
                                    // try {
                                    //   final UserCredential userCredential =
                                    //       await signInWithFacebook();
                                    //   if (context.mounted) {
                                    //     Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: (context) => Home(),
                                    //       ),
                                    //     );
                                    //   }
                                    // } catch (e) {
                                    //   ScaffoldMessenger.of(context)
                                    //       .showSnackBar(
                                    //     SnackBar(
                                    //       content: Text(
                                    //           'Failed to sign in with Facebook: $e'),
                                    //     ),
                                    //   );
                                    //   print(e.toString());
                                    // }
                                  },
                                  child: Image.asset(
                                    "assets/images/Facebook.png",
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(TextConstants.notMember,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryDark,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    widget.controller.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  },
                                  child: Text(TextConstants.register,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.primaryHighContrast,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Perform Facebook login
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Access the access token from the login result
  //   final AccessToken? accessToken = loginResult.accessToken;

  //   // Check if access token is not null
  //   if (accessToken != null) {
  //     // If access token is available, create FacebookAuthProvider credential
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(accessToken.token);

  //     // Sign in with Firebase using the Facebook auth credential
  //     return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   } else {
  //     // Handle the case where access token is null
  //     throw Exception('Failed to obtain Facebook access token');
  //   }
  // }
}
