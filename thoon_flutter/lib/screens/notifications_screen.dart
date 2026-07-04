import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../components/gold_label_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Notifications Screen
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationItem {
  final String title;
  final String body;
  final IconData icon;
  final String time;
  final bool isRead;
  final ChipVariant chipVariant;
  final String chipLabel;

  const _NotificationItem({
    required this.title,
    required this.body,
    required this.icon,
    required this.time,
    this.isRead = false,
    this.chipVariant = ChipVariant.gold,
    required this.chipLabel,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_NotificationItem> _todayItems = [
    const _NotificationItem(
      title: 'Employee Assigned 👷',
      body: 'Muthu Swamy (Master Mason) has been assigned to your complaint THN-998822.',
      icon: Icons.person_add_alt_1_rounded,
      time: '2:45 PM',
      chipVariant: ChipVariant.blue,
      chipLabel: 'COMPLAINT',
    ),
    const _NotificationItem(
      title: 'Gold Privilege Active 🎖️',
      body: 'உங்கள் கட்டுமான வேலைகளுக்கு 15% தள்ளுபடி உள்ளது! Valid till June 30.',
      icon: Icons.workspace_premium_rounded,
      time: '10:00 AM',
      chipVariant: ChipVariant.gold,
      chipLabel: 'OFFER',
    ),
    const _NotificationItem(
      title: 'Payment Confirmed 💳',
      body: 'Site visit payment of ₹100 received successfully. Receipt generated.',
      icon: Icons.check_circle_rounded,
      time: '9:15 AM',
      isRead: true,
      chipVariant: ChipVariant.green,
      chipLabel: 'PAYMENT',
    ),
  ];

  final List<_NotificationItem> _earlierItems = [
    const _NotificationItem(
      title: 'Complaint Registered 📋',
      body: 'Your complaint ID THN-998822 for Bathroom Tile Crack has been submitted.',
      icon: Icons.assignment_rounded,
      time: 'Yesterday, 4:30 PM',
      isRead: true,
      chipVariant: ChipVariant.orange,
      chipLabel: 'COMPLAINT',
    ),
    const _NotificationItem(
      title: 'Summer Renovation Offer 🏠',
      body: 'Get 15% OFF on premium bathroom tiling renovations. Book before June 30.',
      icon: Icons.local_offer_rounded,
      time: 'May 27',
      isRead: true,
      chipVariant: ChipVariant.gold,
      chipLabel: 'OFFER',
    ),
    const _NotificationItem(
      title: 'Service Completed ✅',
      body: 'Your Water Pipes Leakage Repair has been marked complete by Aravind Krishnan.',
      icon: Icons.done_all_rounded,
      time: 'May 25',
      isRead: true,
      chipVariant: ChipVariant.green,
      chipLabel: 'SERVICE',
    ),
    const _NotificationItem(
      title: 'Site Visit Scheduled 📅',
      body: 'Your Living Room Repaint site visit is confirmed for May 24 at 02:00 PM.',
      icon: Icons.calendar_today_rounded,
      time: 'May 23',
      isRead: true,
      chipVariant: ChipVariant.blue,
      chipLabel: 'BOOKING',
    ),
  ];

  int get _unreadCount =>
      [..._todayItems, ..._earlierItems].where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      // In production, call API to mark all read
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'All notifications marked as read',
          style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ThoonTheme.goldPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: ThoonTheme.goldPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: ThoonTheme.goldGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_unreadCount',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ]
          ],
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  color: ThoonTheme.goldPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // ── Today Section ─────────────────────────────────────────────
          _buildSectionLabel('TODAY'),
          const SizedBox(height: 12),
          ..._todayItems.map((item) => _buildNotificationCard(item)),

          const SizedBox(height: 30),

          // ── Earlier Section ───────────────────────────────────────────
          _buildSectionLabel('EARLIER'),
          const SizedBox(height: 12),
          ..._earlierItems.map((item) => _buildNotificationCard(item)),

          const SizedBox(height: 40),

          // ── Empty State Illustration ──────────────────────────────────
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: ThoonTheme.textMuted.withOpacity(0.3),
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'re all caught up!',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ThoonTheme.textMuted.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: ThoonTheme.goldPrimary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildNotificationCard(_NotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.isRead
            ? ThoonTheme.cardBg
            : ThoonTheme.cardBg.withBlue(30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.isRead
              ? Colors.white.withOpacity(0.04)
              : ThoonTheme.goldPrimary.withOpacity(0.15),
        ),
        boxShadow: item.isRead
            ? []
            : [
                BoxShadow(
                  color: ThoonTheme.goldPrimary.withOpacity(0.05),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: ThoonTheme.goldPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                  color: ThoonTheme.goldPrimary.withOpacity(0.3), width: 0.8),
            ),
            child: Icon(item.icon, color: ThoonTheme.goldPrimary, size: 22),
          ),

          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: item.isRead
                              ? FontWeight.w500
                              : FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: ThoonTheme.goldPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item.body,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ThoonTheme.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GoldLabelChip(label: item.chipLabel, variant: item.chipVariant),
                    const Spacer(),
                    Text(
                      item.time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: ThoonTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
