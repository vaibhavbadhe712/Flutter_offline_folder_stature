import 'package:flutter/material.dart';
import '../../routing/router.dart'; 

class ToastServices {
  ToastServices._();

  static void showToast({
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 4),
  }) {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 4.0,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: backgroundColor,
          duration: duration,
          content: Row(
            children: [
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        color: textColor.withOpacity(0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  static void success(String title, String message) {
    showToast(
      title: title,
      message: message,
      backgroundColor: const Color(0xFF10B981), // success green
      textColor: Colors.white,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void error(String title, String message) {
    showToast(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFEF4444), // error red
      textColor: Colors.white,
      icon: Icons.error_outline_rounded,
    );
  }

  static void warning(String title, String message) {
    showToast(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFF59E0B), // warning amber
      textColor: Colors.white,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void info(String title, String message) {
    showToast(
      title: title,
      message: message,
      backgroundColor: const Color(0xFF3B82F6), // info blue
      textColor: Colors.white,
      icon: Icons.info_outline_rounded,
    );
  }

  static void dismissAll() {
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }
}