import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardStyle {
  static List<Color> cardColors = const [
    Color(0xFFFFC0CB), // Light Pink
    Color(0xFFE6E6FA), // Pale Lavender
    Color(0xFFFFDAB9), // Peach
    Color(0xFF98FB98), // Mint Green
    Color(0xFFADD8E6), // Light Blue
    Color(0xFFB0E0E6), // Lavender
    Color(0xFFFFFFE0), // Pale Yellow
    Color(0xFFD3D3D3), // Light Gray
    Color(0xFF98FB98), // Pale Green
    Color(0xFFA9A9A9), // Light Purple
    Color(0xFFFF0000), // Red
    Color(0xFF008000), // Green
    Color(0xFF0000FF), // Blue
    Color(0xFFFFFF00), // Yellow
    Color(0xFF800080), // Purple
    Color(0xFF008080), // Teal
    Color(0xFFFFA500), // Orange
    Color(0xFF808080), // Gray
  ];

  static TextStyle title = GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle date = GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500);
  static TextStyle content = GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.normal);

  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate the relative luminance of the background color
    final bgLuminance = (0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue) / 255;

    // You can adjust this threshold to your preference
    // If the background is light, use dark text; otherwise, use light text
    return bgLuminance > 0.5 ? Colors.black : Colors.white;
  }


}