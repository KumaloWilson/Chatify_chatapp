// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, unnecessary_string_interpolations, unnecessary_brace_in_string_interps
// ignore_for_file: unrelated_type_equality_checks, camel_case_types
import 'dart:io';
import 'package:chat_app/app/utils/components/profilepageshimmer.dart';
import 'package:chat_app/app/view/root/root.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:chat_app/app/controller/profile/bloc/profile_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  String? imageUrl;
  String? name;
  String? id;
  File? pickedImage;
  TextEditingController nameEditingController = TextEditingController();

  PaletteGenerator? paletteGenerator;

  void generatecolor(String imageUrl) async {
    if (imageUrl != null) {
      try {
        ImageProvider img = NetworkImage(imageUrl!);
        paletteGenerator = await PaletteGenerator.fromImageProvider(img);
        setState(() {});
      } catch (e) {
        print("No Image Found");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color.fromRGBO(64, 105, 225, 1);
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileImagePickedSuccessState) {
          setState(() {
            pickedImage = state.image;
          });
          BlocProvider.of<ProfileBloc>(context)
              .add(ProfileSaveToDbEvent(image: pickedImage));
        } else if (state is ProfileImageUpdatedSuccessState) {
          setState(() {
            pickedImage = null;
          });
        }
        if (state is LogoutDoneState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthenticationScreen()),
          );
        } else if (state is UserDeletedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthenticationScreen()),
          );
        }
      },
      builder: (context, state) {
        BlocProvider.of<ProfileBloc>(context).add(FetchingUserDataEvent());
        if (state is UserDataFectchedDone) {
          name = state.name;
          imageUrl = state.imageUrl;
          id = state.id;

          generatecolor(imageUrl!);

          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              "assets/images/chat_background.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Profile",
                                  style: GoogleFonts.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                                IconButton.filled(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent)),
                                    onPressed: () {
                                      BlocProvider.of<ProfileBloc>(context)
                                          .add(ProfileImageUpdateEvent());
                                      BlocProvider.of<ProfileBloc>(context).add(
                                          ProfileSaveToDbEvent(
                                              image: pickedImage));
                                    },
                                    icon: Icon(Iconsax.edit_2,
                                        color: Colors.black))
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: constraints.maxHeight < 600 ? 20 : 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.3 /
                                      2,
                                  width: 140,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: paletteGenerator != null
                                                ? paletteGenerator!
                                                            .vibrantColor !=
                                                        null
                                                    ? paletteGenerator!
                                                        .vibrantColor!.color
                                                    : Colors.black
                                                : Colors.black,
                                            blurRadius: 80,
                                            spreadRadius: 2,
                                            blurStyle: BlurStyle.outer)
                                      ],
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.teal.withOpacity(0.5),
                                            Colors.purple.withOpacity(0.5),
                                          ])),
                                  clipBehavior: Clip.antiAlias,
                                  child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: pickedImage != null
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                                strokeAlign: 30,
                                                strokeWidth: 3,
                                              ),
                                            )
                                          : imageUrl != null
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(imageUrl!),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets.all(
                                                      28.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.black,
                                                  ),
                                                )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$name',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Verified ",
                                            style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green),
                                          ),
                                          Icon(
                                            Iconsax.tick_circle,
                                            size: 14,
                                            color: Colors.green,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            )),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 5,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text("Account Overview",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 20),
                            ProfileMenuWidget(
                              title: 'Update Name',
                              onpress: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const SizedBox(height: 16.0),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: Text(
                                                'Enter Your Name',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            TextField(
                                              controller: nameEditingController,
                                              decoration: const InputDecoration(
                                                  suffixIcon: Icon(
                                                    Icons.abc,
                                                    size: 30,
                                                  ),
                                                  hintText:
                                                      'Enter your text...',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)))),
                                            ),
                                            const SizedBox(height: 16.0),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white)),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Cancel',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.red,
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  TextButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .black)),
                                                      onPressed: () {
                                                        BlocProvider.of<
                                                                    ProfileBloc>(
                                                                context)
                                                            .add(ProfileDataSaveEvent(
                                                                userName:
                                                                    nameEditingController
                                                                        .text));
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Save',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: Icons.abc_sharp,
                              color: Colors.teal,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ProfileMenuWidget(
                              title: 'Upload Image',
                              onpress: () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(ProfileImageUpdateEvent());
                                BlocProvider.of<ProfileBloc>(context).add(
                                    ProfileSaveToDbEvent(image: pickedImage));
                              },
                              icon: Iconsax.document_upload,
                              color: Colors.green,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ProfileMenuWidget(
                              title: 'Delete Account',
                              onpress: () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(DeleteButtonClickedEvent());
                              },
                              icon: Iconsax.profile_delete,
                              color: Colors.purple,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ProfileMenuWidget(
                              title: 'Logout',
                              onpress: () {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(LouOutEvent());
                              },
                              icon: Iconsax.logout_1,
                              color: Colors.lightBlueAccent,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ProfileMenuWidget(
                              title: 'Invite Friend',
                              onpress: () {
                                // Share.share("com.example.myapp");
                              },
                              icon: Iconsax.share,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Your personal messagge are ",
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
                    ),
                    TextSpan(
                      text: "end-to-end-encrypted",
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF5B17FE)),
                    ),
                  ])),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        }
        return ProfileSkeletonLoadingIndicator();
      },
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onpress;
  final Color color;

  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onpress,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onpress,
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                color: color,
              ),
            )),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
      ),
      trailing: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.grey[100]),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}
