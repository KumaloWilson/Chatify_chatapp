import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

InputDecoration textFieldDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(
      color: AppColors.primaryHighContrast,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.primaryDark,
      ),
    ),
    errorStyle: GoogleFonts.poppins(color: Colors.red, fontSize: 11),
    errorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        width: 1,
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        width: 1,
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        width: 1,
        color: AppColors.primaryColor,
      ),
    ),
  );
}

textFieldTextStyle() {
  return TextStyle(
    color: AppColors.darkGrey,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
}
