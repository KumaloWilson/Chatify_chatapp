import 'package:chat_app/app/view/util/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextConstants {
  static const String appTitle = 'Welcome back you\'ve been missed!';

  static TextStyle titleStyle(BuildContext context) {
    return TextStyle(
      color: AppColors.primaryHighContrast,
      fontSize: 16,
    );
  }

  static const String register = 'Sign Up';

  static const String notMember = 'Not a member ?';

  static const String continueWith = 'Or continue with';

  static const String forgot = 'Forgot Password?';

  static const String login = "Login";
}

Padding continueWIth(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: AppColors.primaryDark,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(TextConstants.continueWith,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryHighContrast,
              )),
        ),
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    ),
  );
}

class SquareTile extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const SquareTile({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryDark),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}

