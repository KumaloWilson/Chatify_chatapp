// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

sealed class AuthActionState extends AuthState {}

final class AuthInitial extends AuthState {}

class RegisterPageNavigatedState extends AuthActionState {}

class LoginPageNavigateDoneState extends AuthActionState {}

class LoggedInSuccessState extends AuthActionState {}

class LoginloadingState extends AuthState {
  final bool loading;
  LoginloadingState({
    required this.loading,
  });
}

class LoggedInErrorState extends AuthActionState {
  final String error;
  LoggedInErrorState({
    required this.error,
  });
}

class RegisteredSuccessState extends AuthActionState {
  final String uid;
  RegisteredSuccessState({
    required this.uid,
  });
}

class RegisteredErrorState extends AuthActionState {
  final String message;
  RegisteredErrorState({
    required this.message,
  });
}

class ImagePickedSuccessState extends AuthActionState {
  File image;
  ImagePickedSuccessState({
    required this.image,
  });
}

class ImagePickedErrorState extends AuthActionState {
  final String error;
  ImagePickedErrorState({
    required this.error,
  });
}

class UserDataUpdatedState extends AuthActionState {}

class UserDataUpdateErrorState extends AuthActionState {
  final String error;
  UserDataUpdateErrorState({
    required this.error,
  });
}

class GoogleButtonState extends AuthActionState {}
