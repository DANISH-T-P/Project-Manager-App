import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class CustomSnackbar {
  static void success(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void error(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.error,
    );
  }

  static void warning(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }

  static void info(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
    );
  }

  // Nested Console Message Variants
  static final console = _ConsoleSnackbar();

  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    TextStyle? textStyle,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor.withOpacity(0.95),
      colorText: textStyle?.color ?? Colors.white,
      icon: Icon(icon, color: textStyle?.color ?? Colors.white),
      borderRadius: 12,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      messageText: Text(
        message,
        style: textStyle ??
            const TextStyle(color: Colors.white, fontSize: 14),
      ),
      titleText: Text(
        title,
        style: textStyle?.copyWith(fontWeight: FontWeight.bold, fontSize: 16) ??
            const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Internal class for console-style messages
class _ConsoleSnackbar {

  void success(String title, String message) {
    print("✅ Console Success - $title: $message");
    if (kDebugMode) {
      print("✅ Console Success - $title: $message");
    }
  }

  void error(String title, String message) {
    print("❌ Console Error - $title: $message");
    if (kDebugMode) {
      print("❌ Console Error - $title: $message");
    }
  }

  void warning(String title, String message) {
    print("⚠️ Console Warning - $title: $message");
    if (kDebugMode) {
      print("⚠️ Console Warning - $title: $message");
    }
  }

  void info(String title, String message) {
    print("ℹ️ Console Info - $title: $message");
    if (kDebugMode) {
      print("ℹ️ Console Info - $title: $message");
    }
  }

}
