import 'package:flutter/material.dart';

class TextConstants {
  static const String appTitle = 'Welcome back you\'ve been missed!';

  static TextStyle titleStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 16,
    );
  }

  static const String register = 'Register now';

  static TextStyle registerStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static const String notMember = 'Not a member?';

  static TextStyle primarystyle(BuildContext context) {
    return TextStyle(color: Theme.of(context).colorScheme.primary);
  }

  static const String continueWith = 'Or continue with';

  static const String forgot = 'Forgot Password?';

  static TextStyle forgotStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  static const String login = "Login";
}
