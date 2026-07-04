import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

String get currentUserName =>
    FirebaseAuth.instance.currentUser?.displayName ?? 'User';
String? get currentUserPhoto =>
    FirebaseAuth.instance.currentUser?.photoURL;
String get currentUserEmail =>
    FirebaseAuth.instance.currentUser?.email ?? 'No email';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Profile Screen (Enhanced)
// Added: WhatsApp/Call support buttons, loyalty points badge
// ─────────────────────────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse(
        'https://wa.me/${AppConstants.supportWhatsApp}?text=Hello%20THOON%20Support%2C%20I%20need%20help%20with%20my%20service.');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp not installed')),
        );
      }
    }
  }

  Future<void> _launchCall(BuildContext context) async {
    final url = Uri.parse('tel:${AppConstants.supportPhone}');
    if (!await launchUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot make a call')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 70),

            // ── Profile Header ────────────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ThoonTheme.goldPrimary, width: 2.5),
                          image:  DecorationImage(
                            image: NetworkImage(currentUserPhoto ??
                                'https://i.pravatar.cc/150?img=33'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: ThoonTheme.goldGlow,
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: ThoonTheme.goldGradient,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: ThoonTheme.darkBg, width: 2),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              color: Colors.black, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUserName,
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentUserEmail,
                    style: GoogleFonts.inter(
                        fontSize: 12, color: ThoonTheme.textMuted),
                  ),
                  const SizedBox(height: 14),
                  // Membership Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: ThoonTheme.goldGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: ThoonTheme.goldGlow,
                    ),
                    child: Text(
                      'GOLD PRIVILEGE MEMBER',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Loyalty Points ──────────────────────────────────────
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ThoonTheme.cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: ThoonTheme.goldPrimary.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('2,450', 'Loyalty Pts',
                            Icons.stars_rounded),
                        Container(
                            height: 40,
                            width: 1,
                            color: Colors.white.withOpacity(0.08)),
                        _buildStatItem(
                            '8', 'Services', Icons.handyman_rounded),
                        Container(
                            height: 40,
                            width: 1,
                            color: Colors.white.withOpacity(0.08)),
                        _buildStatItem(
                            '4.9', 'Rating', Icons.star_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Address ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildLabel('YOUR ADDRESS / முகவரி'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThoonTheme.cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: ThoonTheme.goldPrimary, size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home Address',
                            style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'No. 45, Golden Plaza, Nungambakkam, Chennai - 600034',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: ThoonTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_rounded,
                        color: ThoonTheme.goldPrimary, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Support Buttons ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildLabel('INSTANT SUPPORT / உடனடி உதவி'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  // WhatsApp Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _launchWhatsApp(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF075E54).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: const Color(0xFF25D366).withOpacity(0.4)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.chat_rounded,
                                color: Color(0xFF25D366), size: 26),
                            const SizedBox(height: 6),
                            Text(
                              'WhatsApp',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF25D366),
                              ),
                            ),
                            Text(
                              'Chat Support',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: ThoonTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Call Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _launchCall(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: ThoonTheme.goldPrimary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color:
                                  ThoonTheme.goldPrimary.withOpacity(0.4)),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.call_rounded,
                                color: ThoonTheme.goldPrimary, size: 26),
                            const SizedBox(height: 6),
                            Text(
                              'Call Us',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: ThoonTheme.goldPrimary,
                              ),
                            ),
                            Text(
                              'Phone Support',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: ThoonTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Settings Menu ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildLabel('SETTINGS & UTILITIES'),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: ThoonTheme.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    _buildSettingsRow(
                        Icons.payment_rounded,
                        'Payment History & Invoices'),
                    _buildSettingsRow(
                        Icons.security_update_good_rounded,
                        'Security Settings'),
                    _buildSettingsRow(
                        Icons.support_agent_rounded,
                        'Customer Support & Help'),
                    _buildSettingsRow(
                        Icons.info_outline_rounded,
                        'About THOON Services'),
                    _buildSettingsRow(
                        Icons.notifications_none_rounded,
                        'Notification Preferences'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ── Logout ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.redAccent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      'LOGOUT / வெளியேறு',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: ThoonTheme.goldPrimary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: ThoonTheme.goldPrimary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style:
              GoogleFonts.inter(fontSize: 10, color: ThoonTheme.textMuted),
        ),
      ],
    );
  }

  Widget _buildSettingsRow(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(color: Colors.white.withOpacity(0.03), width: 1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: ThoonTheme.goldPrimary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style:
                  GoogleFonts.inter(fontSize: 14, color: Colors.white),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: ThoonTheme.textMuted, size: 12),
        ],
      ),
    );
  }
}
