import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardStyle {
  static List<Color> cardColors = [
    Colors.white,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
    Colors.lightGreen.shade900,
    Colors.amberAccent.shade100,
    Colors.cyan.shade100,
    Colors.deepPurpleAccent.shade100,
    Colors.indigoAccent.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.limeAccent.shade100,
    Colors.purple.shade100,
    Colors.teal.shade100,
  ];

  static TextStyle title = GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle date = GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500);
  static TextStyle content = GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal);
}