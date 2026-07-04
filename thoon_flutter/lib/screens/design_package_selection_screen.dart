import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'payment_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Design Package Selection Screen
// ─────────────────────────────────────────────────────────────────────────────

class DesignPackageSelectionScreen extends StatefulWidget {
  final String category;
  final String subCategory;

  const DesignPackageSelectionScreen({
    super.key,
    required this.category,
    required this.subCategory,
  });

  @override
  State<DesignPackageSelectionScreen> createState() => _DesignPackageSelectionScreenState();
}

class _DesignPackageSelectionScreenState extends State<DesignPackageSelectionScreen> {
  String _selectedPackage = 'Basic'; // 'Basic' or 'Premium'

  void _proceedToPayment() {
    final price = _selectedPackage == 'Basic' ? '₹1,499' : '₹3,500';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          serviceTitle: '${widget.category} ($_selectedPackage Package)',
          price: price,
        ),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ThoonTheme.goldPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Package',
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
            Text(
              'Choose your consultation plan for\n${widget.category} - ${widget.subCategory}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: ThoonTheme.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // ── Basic Package ─────────────────────────────────────────
            _buildPackageCard(
              title: 'Basic Consultation',
              price: '₹1,499',
              packageType: 'Basic',
              features: [
                'Expert Design Consultation',
                '2D Layout Planning',
                'First 2 Corrections Included',
                'Additional Corrections ₹100 Each',
              ],
            ),

            const SizedBox(height: 20),

            // ── Premium Package ───────────────────────────────────────
            _buildPackageCard(
              title: 'Premium Consultation',
              price: '₹3,500',
              packageType: 'Premium',
              isPremium: true,
              features: [
                'Expert Design Consultation',
                '3D Layout & Rendering',
                'Walkthrough Video Included',
                'First 2 Corrections Included',
                'Additional Corrections ₹100 Each',
              ],
            ),

            const SizedBox(height: 40),

            // ── Proceed Button ────────────────────────────────────────
            GestureDetector(
              onTap: _proceedToPayment,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: ThoonTheme.goldGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: ThoonTheme.goldGlow,
                ),
                child: Center(
                  child: Text(
                    'PROCEED TO PAYMENT',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard({
    required String title,
    required String price,
    required String packageType,
    required List<String> features,
    bool isPremium = false,
  }) {
    final isSelected = _selectedPackage == packageType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPackage = packageType;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? ThoonTheme.goldPrimary.withOpacity(0.05) : ThoonTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? ThoonTheme.goldPrimary : Colors.white.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: ThoonTheme.goldPrimary.withOpacity(0.1), blurRadius: 10, spreadRadius: 1)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          gradient: ThoonTheme.goldGradient,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'RECOMMENDED',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? ThoonTheme.goldPrimary : ThoonTheme.textMuted,
                      width: 2,
                    ),
                    color: isSelected ? ThoonTheme.goldPrimary : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded, color: Colors.black, size: 16)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              price,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: ThoonTheme.goldPrimary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: ThoonTheme.goldPrimary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feature,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
