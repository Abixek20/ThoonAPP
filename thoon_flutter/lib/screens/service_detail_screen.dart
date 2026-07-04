import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'payment_screen.dart';
import 'site_visit_booking_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Service Detail Screen (Enhanced)
// Added: Dual CTA (Book Site Visit + Book Service), Reviews section, Share icon
// ─────────────────────────────────────────────────────────────────────────────

class ServiceDetailScreen extends StatelessWidget {
  final Map<String, dynamic> service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Banner ───────────────────────────────────────────
                Stack(
                  children: [
                    Image.network(
                      service['image'],
                      height: size.height * 0.36,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                          height: size.height * 0.36,
                          color: ThoonTheme.cardBgElevated),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                              Colors.black,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Offer badge if discounted
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: ThoonTheme.goldGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'VERIFIED SERVICE',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      // Category chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThoonTheme.goldPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  ThoonTheme.goldPrimary.withOpacity(0.4)),
                        ),
                        child: Text(
                          service['category'],
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: ThoonTheme.goldPrimary,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        service['title'],
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: ThoonTheme.cardBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ThoonTheme.goldPrimary
                                      .withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: ThoonTheme.goldPrimary, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  service['rating'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '128 Reviews',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: ThoonTheme.textMuted),
                          ),
                          const Spacer(),
                          Text(
                            service['price'],
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: ThoonTheme.goldPrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── Professional Card ─────────────────────────────
                      _buildSectionLabel('ASSIGNED PROFESSIONAL / நிபுணர்'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ThoonTheme.cardBg,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(
                                  'https://i.pravatar.cc/150?img=12'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service['expert'],
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Verified Luxury Builder Partner',
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: ThoonTheme.goldPrimary),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 38,
                                width: 38,
                                decoration: BoxDecoration(
                                  color: ThoonTheme.goldPrimary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color:
                                          ThoonTheme.goldPrimary.withOpacity(0.3)),
                                ),
                                child: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    color: ThoonTheme.goldPrimary,
                                    size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Description ───────────────────────────────────
                      _buildSectionLabel(
                          'SERVICE DESCRIPTION / சேவை விளக்கம்'),
                      const SizedBox(height: 12),
                      Text(
                        service['desc'],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: ThoonTheme.textMuted,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Gold Standards ────────────────────────────────
                      _buildSectionLabel('THOON GOLD STANDARDS'),
                      const SizedBox(height: 12),
                      _buildStandardRow(Icons.security_rounded,
                          '3 Years Full Structural Integrity Warranty'),
                      _buildStandardRow(Icons.workspace_premium_rounded,
                          'Certified Premium Materials Only'),
                      _buildStandardRow(Icons.timer_rounded,
                          'On-Time Fix or Refund Guarantee'),
                      _buildStandardRow(Icons.verified_user_rounded,
                          'ISO Certified Construction Process'),

                      const SizedBox(height: 28),

                      // ── Customer Reviews ──────────────────────────────
                      _buildSectionLabel('CUSTOMER REVIEWS / வாடிக்கையாளர் கருத்து'),
                      const SizedBox(height: 12),
                      _buildReviewCard(
                        name: 'Vikram Nair',
                        rating: 5,
                        review:
                            'Exceptional craftsmanship! The team completed the tiling work ahead of schedule with perfect alignment.',
                        date: 'May 15, 2026',
                        avatarUrl: 'https://i.pravatar.cc/150?img=5',
                      ),
                      const SizedBox(height: 12),
                      _buildReviewCard(
                        name: 'Priya Sundaram',
                        rating: 5,
                        review:
                            'Very professional team. The paint finish is flawless – exactly the luxurious look we wanted.',
                        date: 'April 28, 2026',
                        avatarUrl: 'https://i.pravatar.cc/150?img=9',
                      ),
                      const SizedBox(height: 12),
                      _buildReviewCard(
                        name: 'Rajan Murugan',
                        rating: 4,
                        review:
                            'Great work overall. Minor delay but the quality was worth waiting for. Highly recommend.',
                        date: 'April 10, 2026',
                        avatarUrl: 'https://i.pravatar.cc/150?img=15',
                      ),

                      // Extra space for bottom CTA
                      const SizedBox(height: 140),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Back Button ──────────────────────────────────────────────────
          Positioned(
            top: 48,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 16),
              ),
            ),
          ),

          // ── Share Button ─────────────────────────────────────────────────
          Positioned(
            top: 48,
            right: 20,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.share_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ),

          // ── Dual CTA Bar ─────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              decoration: BoxDecoration(
                color: ThoonTheme.darkBg,
                border: Border(
                    top: BorderSide(
                        color: Colors.white.withOpacity(0.06))),
              ),
              child: Row(
                children: [
                  // Site Visit button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SiteVisitBookingScreen(
                              serviceTitle: service['title'],
                              serviceCategory: service['category'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: ThoonTheme.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: ThoonTheme.goldPrimary.withOpacity(0.5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.home_work_rounded,
                                color: ThoonTheme.goldPrimary, size: 18),
                            const SizedBox(height: 2),
                            Text(
                              'SITE VISIT – ₹100',
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ThoonTheme.goldPrimary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Book Service button
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              serviceTitle: service['title'],
                              price: service['price'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: ThoonTheme.goldGradient,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: ThoonTheme.goldGlow,
                        ),
                        child: Center(
                          child: Text(
                            'BOOK NOW / முன்பதிவு செய்',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  Widget _buildStandardRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: ThoonTheme.goldPrimary, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required int rating,
    required String review,
    required String date,
    required String avatarUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: ThoonTheme.textMuted),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: ThoonTheme.goldPrimary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: ThoonTheme.textMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
