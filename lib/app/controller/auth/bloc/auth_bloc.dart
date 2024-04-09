// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  User? user;

  AuthBloc() : super(AuthInitial()) {
    on<UpdateUserDataEvent>(updateUserDataEvent);
    on<LoginpagePageNavigateEvent>(loginpagePageNavigateEvent);
    on<RegisterPageNavigateEvent>(registerPageNavigateEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<RegisterButtonClickedEvent>(registerButtonClickedEvent);
    on<PickImageFromGalleryEvent>(pickImageFromGalleryEvent);
    on<GoogleButtonClickedEvent>(googleButtonClickedEvent);
  }

  FutureOr<void> loginpagePageNavigateEvent(
      LoginpagePageNavigateEvent event, Emitter<AuthState> emit) {
    emit(LoginPageNavigateDoneState());
  }

  FutureOr<void> registerPageNavigateEvent(
      RegisterPageNavigateEvent event, Emitter<AuthState> emit) {
    emit(RegisterPageNavigatedState());
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<AuthState> emit) async {
    emit(LoginloadingState(loading: true));
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      user = result.user;
      print("logged in success");
      emit(LoggedInSuccessState());
      // navigate to home page
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code, emit);
    } catch (e) {
      print("logged in error: $e");
      emit(LoggedInErrorState(error: 'An unexpected error occurred.'));
      // display an error
    }
  }

  void exceptionHandler(String code, Emitter<AuthState> emit) {
    switch (code) {
      case "invalid-credential":
        emit(LoggedInErrorState(error: "invalid email or password."));
        break;
      case "weak-password":
        emit(LoggedInErrorState(
            error: "Your password must be at least 6 characters long."));
        break;
      case "email-already-in-use":
        emit(LoggedInErrorState(error: "The email address is already in use."));
        break;
      default:
        emit(LoggedInErrorState(
            error: "An unexpected error occurred Please try again later."));
        break;
    }
  }

  FutureOr<void> registerButtonClickedEvent(
      RegisterButtonClickedEvent event, Emitter<AuthState> emit) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);

      user = result.user;

      emit(RegisteredSuccessState(uid: user!.uid));
    } catch (e) {
      emit(RegisteredErrorState(message: e.toString()));
    }
  }

  FutureOr<void> pickImageFromGalleryEvent(
      PickImageFromGalleryEvent event, Emitter<AuthState> emit) async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(ImagePickedSuccessState(image: File(pickedFile.path)));
      } else {
        emit(ImagePickedErrorState(error: 'Please select an image.'));
      }
    } catch (e) {
      emit(ImagePickedErrorState(error: 'Error picking image: $e'));
      print(e.toString());
    }
  }

//while updatinng the user data i need to get the happend the authentication too

  FutureOr<void> updateUserDataEvent(
      UpdateUserDataEvent event, Emitter<AuthState> emit) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);

      user = result.user;
      // Upload profile image to Firebase Storage
      String imageUrl =
          await uploadProfileImage(storageRef, user!.uid, event.imageUrl);

      // Update user data in Firestore
      await updateUserDataInFirestore(
          user!.uid, event.name, event.email, imageUrl);

      emit(UserDataUpdatedState());
    } catch (e) {
      emit(UserDataUpdateErrorState(error: 'Error updating user data: $e'));
    }
  }

  Future<String> uploadProfileImage(
      Reference storageRef, String uid, File image) async {
    TaskSnapshot result =
        await storageRef.child('profile_images').child(uid).putFile(image);

    return await result.ref.getDownloadURL();
  }

  Future<void> updateUserDataInFirestore(
      String uid, String name, String email, String imageUrl) async {
    String usercollection = "Users";
    await db.collection(usercollection).doc(uid).set({
      'name': name,
      'email': email,
      'image': imageUrl,
      'lastSeen': DateTime.now().toUtc(),
      'uid': uid,
    });
  }

  FutureOr<void> googleButtonClickedEvent(
      GoogleButtonClickedEvent event, Emitter<AuthState> emit) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // Sign out from GoogleSignIn (clear cached credentials)
      await googleSignIn.signOut();

      // Sign out from FirebaseAuth (clear authentication state)
      await FirebaseAuth.instance.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set({
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'image': userCredential.user!.photoURL,
          'uid': userCredential.user!.uid,
          'date': DateTime.now(),
        });
        emit(GoogleButtonState());
      }
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
