import 'package:chat_app/app/controller/auth/bloc/auth_bloc.dart';
import 'package:chat_app/app/utils/constants/validators.dart';
import 'package:chat_app/app/view/root/root.dart';
import 'package:chat_app/app/view/upload/uploadimgae.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/app/view/util/styles/app_colors.dart';
import 'package:chat_app/app/view/util/styles/fadeanimation.dart';
import 'package:chat_app/app/view/util/styles/text_field_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final fKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginPageNavigateDoneState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AuthenticationScreen(),
            ),
          );
        } else if (state is RegisteredSuccessState) {
          String uid = state.uid;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UploadProfile(
                    uid: uid,
                    email: _emailController.text,
                    name: _nameController.text,
                    password: _passController.text),
              ));
        } else if (state is RegisteredErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox.fromSize(
          size: MediaQuery.sizeOf(context),
          child: Stack(
            children: [
              Positioned(
                left: 30,
                right: 30,
                bottom: 30,
                child: FadeInAnimation(
                  delay: 1,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.whiteColor.withOpacity(.8),
                    ),
                    child: Form(
                      key: fKey,
                      child: Column(
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign up',
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
                            controller: _nameController,
                            validator: nameValidate,
                            style: textFieldTextStyle(),
                            decoration: textFieldDecoration('Name'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _emailController,
                            validator: emailValidate,
                            style: textFieldTextStyle(),
                            decoration: textFieldDecoration('Email'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _passController,
                            validator: passwordValidate,
                            style: textFieldTextStyle(),
                            decoration: textFieldDecoration('Password'),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.whiteColor,
                              ),
                              onPressed: () async {
                                if (fKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(RegisterButtonClickedEvent(
                                    email: _emailController.text,
                                    password: _passController.text,
                                    name: _nameController.text,
                                  ));
                                }
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: Text(
                                "Create account",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(' have an account ? ',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.primaryDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  )),
                              const SizedBox(
                                width: 2.5,
                              ),
                              InkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  widget.controller.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.ease);
                                },
                                child: Text('Log In ',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryHighContrast,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ],
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
    );
  }
}
