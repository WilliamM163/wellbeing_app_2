import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static TextStyle mainTitle = defaultText.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static TextStyle description = defaultText.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.normal,
  );

  static EdgeInsets appPadding = const EdgeInsets.all(20);

  static TextStyle defaultText = GoogleFonts.urbanist();

  static TextStyle appBarTitle = defaultText.copyWith(
    // fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle tileTitle = defaultText.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  static TextStyle tileDescription = defaultText.copyWith(fontSize: 10);

  static TextStyle tileLink = defaultText.copyWith(fontSize: 12);

  static Color primaryColour = Colors.purple.shade800;

  static Color secondaryColour = Colors.grey;

  // static Color containerColour = primaryColour.withOpacity(0.05);
  static Color containerColour = Colors.white;

  static Color appBarColour = Colors.white;

  static Color drawerColour = Colors.white;

  static Color navigationBarColour = Colors.white;

  static Color backgroundColour = Colors.grey[200]!;

  static List<Color> cardsColor = [
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.cyan.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
  ];
}
