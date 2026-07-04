import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'payment_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Site Visit Booking Screen
// Business Logic: Customer pays site visit fee first. Once project is
// confirmed, the paid amount is credited/adjusted in the final quotation.
// ─────────────────────────────────────────────────────────────────────────────

class SiteVisitBookingScreen extends StatefulWidget {
  final String serviceTitle;
  final String serviceCategory;

  const SiteVisitBookingScreen({
    super.key,
    required this.serviceTitle,
    required this.serviceCategory,
  });

  @override
  State<SiteVisitBookingScreen> createState() => _SiteVisitBookingScreenState();
}

class _SiteVisitBookingScreenState extends State<SiteVisitBookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '10:00 AM – 12:00 PM';
  final TextEditingController _addressController = TextEditingController(
    text: 'No. 45, Golden Plaza, Nungambakkam, Chennai - 600034',
  );

  final double _originalFee = 200;
  final double _offerFee = 100;

  final List<String> _timeSlots = [
    '09:00 AM – 11:00 AM',
    '10:00 AM – 12:00 PM',
    '11:00 AM – 01:00 PM',
    '02:00 PM – 04:00 PM',
    '03:00 PM – 05:00 PM',
    '04:00 PM – 06:00 PM',
  ];

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
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
        title: Text(
          'நேரில் வருகை பதிவு / Book Site Visit',
          style: GoogleFonts.notoSansTamil(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Service Summary ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThoonTheme.cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                        color: ThoonTheme.goldPrimary.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ThoonTheme.goldPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.construction_rounded,
                            color: ThoonTheme.goldPrimary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.serviceTitle,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.serviceCategory,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: ThoonTheme.goldPrimary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Strike Price Offer Card ───────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A1A00), Color(0xFF131313)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: ThoonTheme.goldPrimary.withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_offer_rounded,
                              color: ThoonTheme.goldPrimary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'LIMITED TIME OFFER',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: ThoonTheme.goldPrimary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${_offerFee.toInt()}',
                            style: GoogleFonts.outfit(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              '₹${_originalFee.toInt()}',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                color: ThoonTheme.textMuted,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.redAccent,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green, width: 0.8),
                            ),
                            child: Text(
                              '50% OFF',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Site Visit Fee (credited in final project quote)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: ThoonTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: ThoonTheme.goldPrimary, size: 14),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'This ₹100 will be adjusted against your final project bill.',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: ThoonTheme.goldPrimary.withOpacity(0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Date Picker ───────────────────────────────────────────
                _buildSectionLabel('PREFERRED DATE / விருப்பமான தேதி'),
                const SizedBox(height: 14),
                SizedBox(
                  height: 78,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final date =
                          DateTime.now().add(Duration(days: index + 1));
                      final isSelected = _selectedDate.day == date.day &&
                          _selectedDate.month == date.month;
                      final weekdays = [
                        'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
                      ];
                      final months = [
                        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                        'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                      ];

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = date),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 12),
                          width: 58,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? ThoonTheme.goldGradient
                                : null,
                            color:
                                isSelected ? null : ThoonTheme.cardBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? ThoonTheme.goldPrimary
                                  : Colors.white.withOpacity(0.06),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                weekdays[date.weekday - 1],
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.black
                                      : ThoonTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${date.day}',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                months[date.month - 1],
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  color: isSelected
                                      ? Colors.black
                                      : ThoonTheme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 28),

                // ── Time Slot ─────────────────────────────────────────────
                _buildSectionLabel('SELECT TIME SLOT / நேர பிரிவு'),
                const SizedBox(height: 14),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.8,
                  ),
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, index) {
                    final slot = _timeSlots[index];
                    final isSelected = slot == _selectedSlot;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedSlot = slot),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? ThoonTheme.goldGradient
                              : null,
                          color: isSelected ? null : ThoonTheme.cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? ThoonTheme.goldPrimary
                                : Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            slot,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // ── Address ───────────────────────────────────────────────
                _buildSectionLabel('SITE ADDRESS / இடம்'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: ThoonTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: ThoonTheme.goldPrimary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          maxLines: 2,
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Enter full address',
                            hintStyle:
                                TextStyle(color: ThoonTheme.textMuted),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Summary card before payment ───────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThoonTheme.cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow('Service', widget.serviceTitle),
                      const Divider(color: Colors.white10, height: 20),
                      _buildSummaryRow(
                          'Date',
                          '${['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][_selectedDate.weekday-1]}, ${_selectedDate.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][_selectedDate.month-1]} ${_selectedDate.year}'),
                      const SizedBox(height: 8),
                      _buildSummaryRow('Time Slot', _selectedSlot),
                      const Divider(color: Colors.white10, height: 20),
                      _buildSummaryRow('Site Visit Fee', '₹${_originalFee.toInt()}',
                          isStrike: true),
                      const SizedBox(height: 4),
                      _buildSummaryRow('After Discount', '₹${_offerFee.toInt()}',
                          isGold: true, isBold: true),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky Pay CTA ───────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              decoration: BoxDecoration(
                color: ThoonTheme.darkBg,
                border:
                    Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        serviceTitle: '${widget.serviceTitle} – Site Visit',
                        price: '₹${_offerFee.toInt()}',
                        originalPrice: '₹${_originalFee.toInt()}',
                        isSiteVisit: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: ThoonTheme.goldGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: ThoonTheme.goldGlow,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_rounded,
                          color: Colors.black, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'PAY ₹${_offerFee.toInt()} & CONFIRM VISIT',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildSummaryRow(String label, String value,
      {bool isGold = false, bool isBold = false, bool isStrike = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: ThoonTheme.textMuted,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isGold ? ThoonTheme.goldPrimary : Colors.white,
            decoration: isStrike ? TextDecoration.lineThrough : null,
            decorationColor: Colors.redAccent,
            decorationThickness: 2,
          ),
        ),
      ],
    );
  }
}
