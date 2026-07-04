import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Formatters & Helpers
// ─────────────────────────────────────────────────────────────────────────────

class AppFormatters {
  AppFormatters._();

  /// Format a DateTime to "May 29, 2026"
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format a DateTime to "Today, 04:30 PM"
  static String formatDateRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today, ${DateFormat('hh:mm a').format(date)}';
    } else if (target == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(date)}';
    }
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format currency: 100000 → "₹1,00,000"
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##,##0', 'en_IN');
    return '₹${formatter.format(amount)}';
  }

  /// Generate a THOON complaint reference ID
  static String generateComplaintId() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    return 'THN-${ts.toString().substring(7)}';
  }

  /// Format seconds to mm:ss
  static String formatSeconds(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
