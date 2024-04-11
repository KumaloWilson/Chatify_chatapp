// ignore_for_file: deprecated_member_use

import 'package:chat_app/app/utils/animation/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

void showCustomSnackBar(BuildContext context, String title, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 90,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: AppColors.primaryColor,
            ),
            child: Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.white),
                      ),
                      const Spacer(),
                      Text(
                        message,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20)),
              child: SvgPicture.asset(
                'assets/images/bubbles.svg',
                height: 48,
                width: 40,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            top: -12,
            left: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/back.svg",
                  height: 40,
                  color: Colors.red,
                ),
                Positioned(
                  top: 10,
                  child: SvgPicture.asset(
                    "assets/images/failure.svg",
                    height: 16,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    ),
  );
}
