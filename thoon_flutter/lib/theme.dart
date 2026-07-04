import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThoonTheme {
  static const Color darkBg = Color(0xFF070707);
  static const Color cardBg = Color(0xFF131313);
  static const Color cardBgElevated = Color(0xFF1E1E1E);
  
  // Luxury Gold Palette
  static const Color goldPrimary = Color(0xFFD4AF37); // Classic Gold
  static const Color goldLight = Color(0xFFF3E5AB); // Glow Gold
  static const Color goldAccent = Color(0xFFFFD700); // Bright Accent Gold
  static const Color goldDark = Color(0xFF996515); // Deep Bronze Gold
  
  static const Color textMain = Colors.white;
  static const Color textMuted = Color(0xFFA0A0A0);

  // Gradient definitions for a premium look
  static const Gradient goldGradient = LinearGradient(
    colors: [goldDark, goldAccent, goldLight],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [Color(0xFF151515), Color(0xFF000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Gradient glowGradient = RadialGradient(
    colors: [Color(0x33D4AF37), Colors.transparent],
    radius: 0.8,
  );

  // Custom shadows for high-end glowing visuals
  static List<BoxShadow> goldGlow = [
    BoxShadow(
      color: goldPrimary.withOpacity(0.2),
      blurRadius: 15,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];

  // Modern Typography (Mixed English & Tamil support)
  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: goldPrimary,
      scaffoldBackgroundColor: darkBg,
      cardColor: cardBg,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textMain,
          letterSpacing: 1.5,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: goldPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textMain,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textMuted,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: goldPrimary,
        secondary: goldAccent,
        surface: cardBg,
        background: darkBg,
      ),
    );
  }
}
