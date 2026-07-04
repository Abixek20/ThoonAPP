import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Our Works Screen
// ─────────────────────────────────────────────────────────────────────────────

class OurWorksScreen extends StatelessWidget {
  const OurWorksScreen({super.key});

  final List<Map<String, String>> _portfolioItems = const [
    {
      'title': 'Luxury Villa Construction',
      'location': 'Anna Nagar, Chennai',
      'image': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
    },
    {
      'title': 'Modern Kitchen Interior',
      'location': 'Adyar, Chennai',
      'image': 'https://images.unsplash.com/photo-1556910103-1c02745a8728?w=800',
    },
    {
      'title': 'Swimming Pool Project',
      'location': 'ECR, Chennai',
      'image': 'https://images.unsplash.com/photo-1576013551627-11971f3fc8af?w=800',
    },
    {
      'title': 'Thottam Garden Concept',
      'location': 'OMR, Chennai',
      'image': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ThoonTheme.goldPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Our Works',
          style: GoogleFonts.notoSansTamil(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Text(
              'Transforming Spaces,\nBuilding Dreams',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Over 500+ projects completed with premium quality and dedication.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: ThoonTheme.textMuted,
              ),
            ),
            const SizedBox(height: 32),

            // ── Portfolio Grid ──────────────────────────────────────────────
            Text(
              'PROJECT PORTFOLIO',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ThoonTheme.goldPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _portfolioItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = _portfolioItems[index];
                return _buildPortfolioCard(item);
              },
            ),

            const SizedBox(height: 40),

            // ── Company Location ─────────────────────────────────────────────
            Text(
              'VISIT OUR OFFICE',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ThoonTheme.goldPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: ThoonTheme.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800', // map/office placeholder
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_rounded, color: ThoonTheme.goldPrimary, size: 24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Thoon Headquarters',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '123, Builders Avenue, \nOMR IT Expressway,\nChennai - 600097',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: ThoonTheme.textMuted,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              item['image']!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: ThoonTheme.textMuted, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      item['location']!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
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
