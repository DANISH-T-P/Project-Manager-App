import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  // Primary & Secondary
  static const Color primary = Color(0xFFE23744);
  static const Color secondary = Color(0xFFF7CB45);

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF7CB45); // legacy
  static const Color screenBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF5F5F5);

  // Text
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textOnPrimary = Colors.white;

  // Buttons
  static const Color button = Color(0xFFE23744);
  static const Color buttonText = Colors.white;

  // Borders
  static const Color border = Color(0xFFE0E0E0);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);

  // Icon Colors
  static const Color iconLight = Color(0xFF757575);
  static const Color iconDark = Color(0xFF212121);

  // Transparent & overlays
  static const Color transparent = Colors.transparent;
  static const Color overlay = Color(0x66000000); // semi-transparent black
}
