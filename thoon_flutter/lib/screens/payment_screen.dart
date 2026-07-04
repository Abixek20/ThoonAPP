import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../components/push_notification_overlay.dart';
import 'order_status_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Payment Screen (Enhanced)
// Added: strike price UI, coupon code field, GST calculation row,
//        isSiteVisit flag, originalPrice parameter
// ─────────────────────────────────────────────────────────────────────────────

class PaymentScreen extends StatefulWidget {
  final String serviceTitle;
  final String price;
  final String? originalPrice;
  final bool isSiteVisit;

  const PaymentScreen({
    super.key,
    required this.serviceTitle,
    required this.price,
    this.originalPrice,
    this.isSiteVisit = false,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  bool _isProcessing = false;
  bool _isSuccess = false;
  String _selectedMethod = 'UPI';
  final TextEditingController _couponController = TextEditingController();
  bool _couponApplied = false;

  late AnimationController _successController;
  late Animation<double> _successScale;
  late Animation<double> _successOpacity;

  // Extract numeric value from price string like "₹100" or "₹45 / sq.ft"
  double get _numericPrice {
    final cleaned = widget.price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned.split('.').take(2).join('.')) ?? 0;
  }

  double get _gst => _numericPrice * 0.18;
  double get _total => _numericPrice + _gst;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _successScale = CurvedAnimation(
        parent: _successController, curve: Curves.elasticOut);
    _successOpacity = CurvedAnimation(
        parent: _successController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _successController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _startPayment() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
      _successController.forward();
      PushNotificationOverlay.show(
        context,
        title: 'Payment Confirmed! 💳',
        message:
            'Successfully paid ${widget.price} for ${widget.serviceTitle}. Receipt created.',
        icon: Icons.check_circle_rounded,
      );
    });
  }

  void _applyCoupon() {
    if (_couponController.text.toUpperCase() == 'THOON15') {
      setState(() => _couponApplied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Coupon THOON15 applied! 15% discount activated.',
            style: GoogleFonts.inter(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid coupon code',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
          'பாதுகாப்பான கட்டணம் / Secure Payment',
          style: GoogleFonts.notoSansTamil(
            fontSize: 16,
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Gateway Banner ────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.payment_rounded,
                          color: Colors.blueAccent),
                      const SizedBox(width: 12),
                      Text(
                        'Razorpay Secured Payment Gateway',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                // ── Site Visit Note ───────────────────────────────────────
                if (widget.isSiteVisit) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ThoonTheme.goldPrimary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: ThoonTheme.goldPrimary.withOpacity(0.25)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            color: ThoonTheme.goldPrimary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'This site visit fee of ${widget.price} will be fully credited and adjusted in your final project quotation.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: ThoonTheme.goldPrimary.withOpacity(0.85),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // ── Invoice Summary ───────────────────────────────────────
                _buildLabel('INVOICE SUMMARY / விவரம்'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ThoonTheme.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Column(
                    children: [
                      _buildInvoiceRow('Service Item', widget.serviceTitle,
                          isBold: true),
                      if (widget.originalPrice != null) ...[
                        const SizedBox(height: 12),
                        _buildInvoiceRow(
                            'Original Price', widget.originalPrice!,
                            isStrike: true),
                      ],
                      const SizedBox(height: 12),
                      _buildInvoiceRow('Discounted Price', widget.price),
                      const SizedBox(height: 12),
                      _buildInvoiceRow(
                          'GST (18%)',
                          '₹${_gst.toStringAsFixed(0)}'),
                      if (_couponApplied) ...[
                        const SizedBox(height: 12),
                        _buildInvoiceRow(
                            'Coupon (THOON15)', '- 15%',
                            isGold: false),
                      ],
                      const Divider(color: Colors.white10, height: 24),
                      _buildInvoiceRow(
                          'Total Amount',
                          '₹${(_couponApplied ? _total * 0.85 : _total).toStringAsFixed(0)}',
                          isGold: true,
                          isBold: true),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Coupon Field ──────────────────────────────────────────
                _buildLabel('COUPON CODE / கூப்பன் குறியீடு'),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: ThoonTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _couponApplied
                            ? Colors.green.withOpacity(0.5)
                            : Colors.white.withOpacity(0.06)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        _couponApplied
                            ? Icons.check_circle_rounded
                            : Icons.discount_outlined,
                        color: _couponApplied
                            ? Colors.green
                            : ThoonTheme.goldPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          enabled: !_couponApplied,
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.white,
                              letterSpacing: 1),
                          decoration: InputDecoration(
                            hintText: 'e.g. THOON15',
                            hintStyle: const TextStyle(
                                color: ThoonTheme.textMuted),
                            border: InputBorder.none,
                            suffix: _couponApplied
                                ? null
                                : GestureDetector(
                                    onTap: _applyCoupon,
                                    child: Text(
                                      'APPLY',
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: ThoonTheme.goldPrimary,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Payment Method ────────────────────────────────────────
                _buildLabel('SELECT PAYMENT METHOD'),
                const SizedBox(height: 12),
                _buildPaymentOption(
                    'UPI (GPay, PhonePe, Paytm)',
                    Icons.double_arrow_rounded,
                    'UPI'),
                const SizedBox(height: 10),
                _buildPaymentOption(
                    'Credit / Debit / ATM Card',
                    Icons.credit_card_rounded,
                    'CARD'),
                const SizedBox(height: 10),
                _buildPaymentOption(
                    'Net Banking',
                    Icons.account_balance_rounded,
                    'NETBANKING'),

                const SizedBox(height: 40),

                // ── Pay Button ────────────────────────────────────────────
                GestureDetector(
                  onTap: _startPayment,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: ThoonTheme.goldGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: ThoonTheme.goldGlow,
                    ),
                    child: Center(
                      child: Text(
                        'SECURELY PAY ₹${(_couponApplied ? _total * 0.85 : _total).toStringAsFixed(0)}',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline_rounded,
                          color: ThoonTheme.textMuted, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'SSL 256-Bit Encrypted Secure Connection',
                        style: GoogleFonts.inter(
                            fontSize: 10, color: ThoonTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Processing Overlay ────────────────────────────────────────────
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.85),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ThoonTheme.goldPrimary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Contacting Razorpay Secure Gateway...',
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Success Overlay ───────────────────────────────────────────────
          if (_isSuccess)
            Positioned.fill(
              child: FadeTransition(
                opacity: _successOpacity,
                child: Container(
                  color: ThoonTheme.darkBg,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _successScale,
                          child: Container(
                            height: 110,
                            width: 110,
                            decoration: BoxDecoration(
                              gradient: ThoonTheme.goldGradient,
                              shape: BoxShape.circle,
                              boxShadow: ThoonTheme.goldGlow,
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.black, size: 60),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'PAYMENT SUCCESSFUL',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.isSiteVisit
                              ? 'Site visit fee received. Our team will visit at your scheduled time.\nThis amount will be adjusted in your final quote.'
                              : 'உங்கள் கட்டணம் பெறப்பட்டது. சேவை வல்லுநர் விரைவில் உங்கள் முகவரிக்கு வருவார்.',
                          style: GoogleFonts.notoSansTamil(
                            fontSize: 13,
                            color: ThoonTheme.textMuted,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: Colors.green, width: 0.8),
                          ),
                          child: Text(
                            'Receipt generated • Check your email',
                            style: GoogleFonts.inter(
                                fontSize: 11, color: Colors.green),
                          ),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => OrderStatusScreen(
                                  orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                                  serviceTitle: widget.serviceTitle,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: ThoonTheme.goldGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                'TRACK MY SERVICE',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
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

  Widget _buildInvoiceRow(String label, String value,
      {bool isGold = false,
      bool isBold = false,
      bool isStrike = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: ThoonTheme.textMuted,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
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

  Widget _buildPaymentOption(
      String title, IconData icon, String method) {
    final isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ThoonTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? ThoonTheme.goldPrimary
                : Colors.white.withOpacity(0.04),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: ThoonTheme.goldPrimary, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? ThoonTheme.goldPrimary
                      : ThoonTheme.textMuted,
                  width: isSelected ? 5.5 : 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
