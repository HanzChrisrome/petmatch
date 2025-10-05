import 'package:flutter/material.dart';

var lColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF2BB7A3), // Teal as seed (trust & balance)
  primary: const Color(0xFF2BB7A3), // Teal → primary buttons, highlights
  onPrimary: const Color(0xFF1B7A75), // White text/icons on teal
  secondary: const Color(0xFFFF6F61), // Coral → secondary CTAs, warmth
  onSecondary: Colors.white, // White text/icons on coral
  surface: const Color(0xFFFEEEEE), // Light warm gray for surfaces/cards
  onSurface: const Color(0xFF333333), // Charcoal gray text for readability
  error: const Color(0xFFD32F2F), // Red for errors (material standard)
  onError: Colors.white,
);
