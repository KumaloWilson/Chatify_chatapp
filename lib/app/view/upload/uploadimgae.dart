// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last
import 'dart:io';
import 'package:awesome_widgets/awesome_widgets.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/app/controller/auth/bloc/auth_bloc.dart';
import 'package:chat_app/app/utils/constants/text_constants.dart';
import 'package:chat_app/app/view/home/home.dart';

class UploadProfile extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String uid;

  const UploadProfile({
    Key? key,
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _UploadProfileState createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  File? pickedImage;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ImagePickedErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        } else if (state is ImagePickedSuccessState) {
          pickedImage = state.image;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Done...')));
        } else if (state is UserDataUpdatedState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ));
        } else if (state is UserDataUpdateErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (BuildContext context, AuthState state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  const Text(
                    'Add your Photo',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Get more people to know you',
                      style: TextConstants.primarystyle(context),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: pickedImage != null
                              ? FileImage(pickedImage!)
                              : null,
                        ),
                      ),
                      // Positioned IconButton
                      Positioned(
                        bottom: -9,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: IconButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(PickImageFromGalleryEvent());
                            },
                            icon: const Icon(
                              EneftyIcons.gallery_add_bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Upload",
                    style: TextConstants.primarystyle(context),
                  ),
                  const Spacer(),
                  AwesomeButton.roundedIconButton(
                      onTap: () async {
                        if (pickedImage != null) {
                          BlocProvider.of<AuthBloc>(context).add(
                            UpdateUserDataEvent(
                              uid: widget.uid,
                              name: widget.name,
                              email: widget.email,
                              imageUrl: pickedImage!,
                            ),
                          );
                        }
                      },
                      title: 'Next',
                      width: 300,
                      height: 60,
                      backgroundColor: Colors.black),
                  const Spacer(
                    flex: 1,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
