import 'package:flutter/material.dart';

// var lColorScheme = ColorScheme.fromSeed(
//   brightness: Brightness.light,
//   seedColor: const Color(0xFF2BB7A3), // Teal as seed (trust & balance)
//   primary: const Color(0xFF2BB7A3), // Teal → primary buttons, highlights
//   onPrimary: const Color(0xFF1B7A75), // White text/icons on teal
//   secondary: const Color(0xFFFF6F61), // Coral → secondary CTAs, warmth
//   onSecondary: Colors.white, // White text/icons on coral
//   surface: const Color.fromARGB(
//       255, 240, 240, 240), // Light warm gray for surfaces/cards
//   onSurface: const Color(0xFF333333), // Charcoal gray text for readability
//   error: const Color(0xFFD32F2F), // Red for errors (material standard)
//   onError: Colors.white,
// );

var lColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Colors.white,
  onPrimary: Colors.black, // Black text/icons on white buttons
  secondary: Color(0xFF212121), // Deep charcoal gray as an accent black
  onSecondary: Colors.white, // White text/icons on gray elements
  surface: Color(0xFFF5F5F5), // Very light gray surface for depth
  onSurface:
      Color.fromARGB(255, 44, 43, 43), // Almost-black text for readability
  error: Colors.redAccent, // Standard Material red for errors
  onError: Colors.white,
);
