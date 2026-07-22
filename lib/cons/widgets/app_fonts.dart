import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle poppins(
      BuildContext context, {
        double size = 14,
        FontWeight weight = FontWeight.w400,
        Color color = Colors.black,
      }) {
    final width = MediaQuery.of(context).size.width;

    // Base width: 375 (iPhone design size)
    final scaleFactor = width / 375;

    return GoogleFonts.poppins(
      fontSize: size * scaleFactor,
      fontWeight: weight,
      color: color,
    );
  }
}