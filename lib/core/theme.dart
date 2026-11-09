import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette
  static const Color primaryBlue = Color(0xFF99C1F1);
  static const Color primaryBlueDark = Color(0xFF6BA4E7);
  static const Color primaryBlueLight = Color(0xFFBAE6FD);

  // Accent palette
  static const Color accentPink = Color(0xFFFBB6CE);
  static const Color accentPinkDark = Color(0xFFF472B6);
  static const Color accentPinkLight = Color(0xFFFED7E2);

  // Neutral
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF334155);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, accentPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFFBAE6FD), Color(0xFFFED7E2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.primaryBlue.withValues(alpha: 0.12),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.primaryBlue.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
}
