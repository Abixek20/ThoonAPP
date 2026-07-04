import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Gold Label Chip
// Reusable color-coded status / priority chip.
// ─────────────────────────────────────────────────────────────────────────────

enum ChipVariant { gold, green, orange, red, blue, muted }

class GoldLabelChip extends StatelessWidget {
  final String label;
  final ChipVariant variant;
  final double fontSize;
  final EdgeInsets padding;

  const GoldLabelChip({
    super.key,
    required this.label,
    this.variant = ChipVariant.gold,
    this.fontSize = 9,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  });

  Color get _bgColor {
    switch (variant) {
      case ChipVariant.gold:
        return ThoonTheme.goldPrimary.withOpacity(0.12);
      case ChipVariant.green:
        return Colors.green.withOpacity(0.12);
      case ChipVariant.orange:
        return Colors.orangeAccent.withOpacity(0.12);
      case ChipVariant.red:
        return Colors.redAccent.withOpacity(0.12);
      case ChipVariant.blue:
        return Colors.blueAccent.withOpacity(0.12);
      case ChipVariant.muted:
        return Colors.white.withOpacity(0.06);
    }
  }

  Color get _borderColor {
    switch (variant) {
      case ChipVariant.gold:
        return ThoonTheme.goldPrimary;
      case ChipVariant.green:
        return Colors.green;
      case ChipVariant.orange:
        return Colors.orangeAccent;
      case ChipVariant.red:
        return Colors.redAccent;
      case ChipVariant.blue:
        return Colors.blueAccent;
      case ChipVariant.muted:
        return Colors.white24;
    }
  }

  Color get _textColor {
    switch (variant) {
      case ChipVariant.gold:
        return ThoonTheme.goldPrimary;
      case ChipVariant.green:
        return Colors.green;
      case ChipVariant.orange:
        return Colors.orangeAccent;
      case ChipVariant.red:
        return Colors.redAccent;
      case ChipVariant.blue:
        return Colors.blueAccent;
      case ChipVariant.muted:
        return ThoonTheme.textMuted;
    }
  }

  /// Maps complaint status strings to chip variant
  static ChipVariant variantForStatus(String status) {
    final s = status.toUpperCase();
    if (s.contains('COMPLET')) return ChipVariant.green;
    if (s.contains('PROGRESS') || s.contains('ASSIGNED')) return ChipVariant.blue;
    if (s.contains('PENDING')) return ChipVariant.orange;
    if (s.contains('CANCEL')) return ChipVariant.red;
    return ChipVariant.gold;
  }

  /// Maps priority strings to chip variant
  static ChipVariant variantForPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return ChipVariant.red;
      case 'high':
        return ChipVariant.orange;
      case 'medium':
        return ChipVariant.blue;
      default:
        return ChipVariant.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _borderColor, width: 0.8),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: _textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
