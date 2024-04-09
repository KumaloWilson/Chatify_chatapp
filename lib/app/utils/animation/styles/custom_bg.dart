import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class CustomBackground extends CustomPainter {
  CustomBackground({
    this.firstColor,
    this.secondColor,
  });
  final Color? firstColor;
  final Color? secondColor;

  double width = 0;
  double height = 0;
  @override
  void paint(Canvas canvas, Size size) {
    width = size.width;
    final widthItem = size.width / 3;
    height = size.height;
    final paint = Paint();

    paint.style = PaintingStyle.fill;
    paint.strokeCap = StrokeCap.round;
    paint.strokeWidth = 4;
    paint.shader = ui.Gradient.linear(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), [
      firstColor ?? Colors.lightGreen.shade300,
      secondColor ?? Colors.greenAccent.shade200
    ]);

    final path = Path();

    path.moveTo(width * .04, height * 0.45);
    path.quadraticBezierTo(
      widthItem * 0.25,
      height * 0.58,
      widthItem * 0.5,
      height * 0.4,
    );

    path.quadraticBezierTo(
      widthItem * 0.7,
      height * 0.22,
      widthItem * 0.78,
      height * 0.3,
    );

    path.quadraticBezierTo(
      widthItem * 0.8,
      height * 0.4,
      widthItem,
      height * 0.5,
    );

    path.quadraticBezierTo(
      ((widthItem * 2) * 0.75),
      height * 0.73,
      widthItem * 2,
      height * 0.5,
    );

    path.quadraticBezierTo(
      width * 0.8,
      height * 0.25,
      width * .85,
      height * 0.4,
    );

    path.quadraticBezierTo(
      width * 0.87,
      height * 0.5,
      width * .92,
      height * 0.5,
    );

    path.quadraticBezierTo(
      width * 1,
      height * 0.5,
      width * .95,
      height * 0.35,
    );

    path.quadraticBezierTo(
      width * 0.9,
      height * 0.2,
      width * .8,
      height * 0.15,
    );

    path.quadraticBezierTo(
      width * 0.72,
      height * 0.12,
      widthItem * 2,
      height * 0.2,
    );

    path.quadraticBezierTo(
      widthItem * 1.9,
      height * 0.24,
      widthItem * 1.86,
      height * 0.28,
    );

    path.quadraticBezierTo(
      widthItem * 1.5,
      height * 0.6,
      widthItem * 1.14,
      height * 0.28,
    );

    path.quadraticBezierTo(
      widthItem * 1.1,
      height * 0.24,
      widthItem,
      height * 0.2,
    );

    path.quadraticBezierTo(
      widthItem * 0.7,
      height * 0.1,
      widthItem * 0.4,
      height * 0.2,
    );

    path.quadraticBezierTo(
      widthItem * 0.05,
      height * 0.33,
      width * .04,
      height * 0.45,
    );

    canvas.drawShadow(path, const Color(0xffF52C6A), 30, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
