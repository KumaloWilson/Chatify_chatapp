// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class RegisterPageNavigateEvent extends AuthEvent {}

class LoginpagePageNavigateEvent extends AuthEvent {}

class LoginButtonClickedEvent extends AuthEvent {
  final String email;
  final String password;
  LoginButtonClickedEvent({
    required this.email,
    required this.password,
  });
}

class RegisterButtonClickedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterButtonClickedEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class PickImageFromGalleryEvent extends AuthEvent {}

class UpdateUserDataEvent extends AuthEvent {
  // final String uid;
  final String name;
  final String email;
  final File imageUrl;
  final String password;

  UpdateUserDataEvent({
    // required this.uid,
    required this.password,
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}

class GoogleButtonClickedEvent extends AuthEvent {}
