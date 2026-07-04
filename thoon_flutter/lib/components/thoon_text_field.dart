import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Premium Text Field
// ─────────────────────────────────────────────────────────────────────────────

class ThoonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final bool isActive;

  const ThoonTextField({
    super.key,
    this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.prefixWidget,
    this.suffixWidget,
    this.obscureText = false,
    this.onChanged,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ThoonTheme.goldPrimary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: ThoonTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive
                  ? ThoonTheme.goldPrimary.withOpacity(0.5)
                  : Colors.white.withOpacity(0.06),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: maxLines > 1 ? 12 : 0,
          ),
          child: Row(
            children: [
              if (prefixWidget != null) ...[
                prefixWidget!,
                const SizedBox(width: 12),
                Container(height: 24, width: 1, color: Colors.white.withOpacity(0.1)),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: ThoonTheme.textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: maxLines == 1,
                  ),
                ),
              ),
              if (suffixWidget != null) ...[
                const SizedBox(width: 8),
                suffixWidget!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
