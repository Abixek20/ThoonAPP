import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../utils/constants.dart';
import '../components/thoon_text_field.dart';
import '../components/section_header.dart';
import '../components/push_notification_overlay.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Building Enquiry Screen
// New construction project enquiry / quotation request form.
// ─────────────────────────────────────────────────────────────────────────────

class BuildingEnquiryScreen extends StatefulWidget {
  const BuildingEnquiryScreen({super.key});

  @override
  State<BuildingEnquiryScreen> createState() => _BuildingEnquiryScreenState();
}

class _BuildingEnquiryScreenState extends State<BuildingEnquiryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _plotSizeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedProjectType = AppConstants.projectTypes[0];
  String _selectedBudget = AppConstants.budgetRanges[0];
  bool _hasSitePhoto = false;
  bool _isSubmitting = false;
  bool _isSuccess = false;
  String? _enquiryId;

  late AnimationController _successController;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _plotSizeController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.length < 10 ||
        _plotSizeController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'அனைத்து தேவையான விவரங்களையும் நிரப்பவும்',
            style: GoogleFonts.notoSansTamil(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: ThoonTheme.goldPrimary,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    await Future.delayed(const Duration(seconds: 2));

    final enquiryId = 'ENQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    setState(() {
      _isSubmitting = false;
      _isSuccess = true;
      _enquiryId = enquiryId;
    });

    _successController.forward();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        PushNotificationOverlay.show(
          context,
          title: 'Enquiry Submitted! 🏗️',
          message: 'ID: $enquiryId – Our expert will contact you within 24 hours.',
          icon: Icons.architecture_rounded,
        );
      }
    });
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
          'புதிய கட்டிட விசாரணை / New Building Enquiry',
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
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Banner Card ──────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A1A00), Color(0xFF131313)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                        color: ThoonTheme.goldPrimary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DREAM TO BUILD?',
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: ThoonTheme.goldPrimary,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Get a Free\nQuotation Today',
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Expert consultation within 24 hours',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: ThoonTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: ThoonTheme.goldPrimary.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ThoonTheme.goldPrimary.withOpacity(0.3)),
                        ),
                        child: const Icon(
                          Icons.villa_rounded,
                          color: ThoonTheme.goldPrimary,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ── Contact Info ──────────────────────────────────────────
                const SectionHeader(title: 'YOUR DETAILS / உங்கள் விவரம்'),
                const SizedBox(height: 16),
                ThoonTextField(
                  controller: _nameController,
                  label: 'FULL NAME / பெயர்',
                  hint: 'e.g. Rajan Murugesan',
                  prefixWidget: const Icon(Icons.person_outline_rounded,
                      color: ThoonTheme.goldPrimary, size: 20),
                ),
                const SizedBox(height: 16),
                ThoonTextField(
                  controller: _phoneController,
                  label: 'MOBILE NUMBER / தொலைபேசி',
                  hint: 'Enter 10-digit number',
                  keyboardType: TextInputType.phone,
                  prefixWidget: Text(
                    '+91',
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),

                const SizedBox(height: 30),

                // ── Project Info ──────────────────────────────────────────
                const SectionHeader(title: 'PROJECT DETAILS / திட்ட விவரம்'),
                const SizedBox(height: 16),

                // Project Type Dropdown
                _buildDropdown(
                  label: 'PROJECT TYPE / திட்ட வகை',
                  value: _selectedProjectType,
                  items: AppConstants.projectTypes,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedProjectType = val);
                    }
                  },
                ),

                const SizedBox(height: 16),
                ThoonTextField(
                  controller: _plotSizeController,
                  label: 'PLOT SIZE / நிலம் அளவு',
                  hint: 'e.g. 1200 sq.ft or 30x40 feet',
                  keyboardType: TextInputType.text,
                  prefixWidget: const Icon(Icons.square_foot_rounded,
                      color: ThoonTheme.goldPrimary, size: 20),
                ),

                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'ESTIMATED BUDGET / பட்ஜெட்',
                  value: _selectedBudget,
                  items: AppConstants.budgetRanges,
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedBudget = val);
                  },
                ),

                const SizedBox(height: 16),
                ThoonTextField(
                  controller: _locationController,
                  label: 'SITE LOCATION / இடம்',
                  hint: 'Area, City, Pincode',
                  prefixWidget: const Icon(Icons.location_on_outlined,
                      color: ThoonTheme.goldPrimary, size: 20),
                ),

                const SizedBox(height: 30),

                // ── Site Photo Upload ─────────────────────────────────────
                const SectionHeader(title: 'SITE PHOTO / நிலப் படம் (Optional)'),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => setState(() => _hasSitePhoto = !_hasSitePhoto),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 120,
                    decoration: BoxDecoration(
                      color: ThoonTheme.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _hasSitePhoto
                            ? ThoonTheme.goldPrimary
                            : Colors.white.withOpacity(0.06),
                      ),
                    ),
                    child: Center(
                      child: _hasSitePhoto
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: ThoonTheme.goldPrimary, size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  'Site photo uploaded ✓',
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_rounded,
                                    color:
                                        ThoonTheme.goldPrimary.withOpacity(0.6),
                                    size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to upload site / plot photo',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: ThoonTheme.textMuted),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Additional Notes ──────────────────────────────────────
                ThoonTextField(
                  controller: _notesController,
                  label: 'ADDITIONAL NOTES / கூடுதல் விவரம்',
                  hint:
                      'Any specific requirements, preferred materials, floors, etc...',
                  maxLines: 4,
                ),

                const SizedBox(height: 12),

                // ── Key Benefits row ──────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThoonTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Column(
                    children: [
                      _buildBenefitRow(
                          Icons.verified_rounded, 'Free expert site visit'),
                      const SizedBox(height: 10),
                      _buildBenefitRow(
                          Icons.timer_outlined, 'Quote within 24 hours'),
                      const SizedBox(height: 10),
                      _buildBenefitRow(Icons.workspace_premium_rounded,
                          'No obligation – 100% free'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky Submit Button ─────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              decoration: BoxDecoration(
                color: ThoonTheme.darkBg,
                border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.06))),
              ),
              child: GestureDetector(
                onTap: _isSubmitting ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: ThoonTheme.goldGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: ThoonTheme.goldGlow,
                  ),
                  child: Center(
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : Text(
                            'SUBMIT ENQUIRY / விசாரணை அனுப்பு',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),

          // ── Success Overlay ──────────────────────────────────────────────
          if (_isSuccess)
            Positioned.fill(
              child: Container(
                color: ThoonTheme.darkBg,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ScaleTransition(
                          scale: _successScale,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: ThoonTheme.goldGradient,
                              boxShadow: ThoonTheme.goldGlow,
                            ),
                            child: const Icon(Icons.check_rounded,
                                color: Colors.black, size: 56),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'ENQUIRY SUBMITTED!',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: ThoonTheme.goldPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: ThoonTheme.goldPrimary.withOpacity(0.4)),
                          ),
                          child: Text(
                            'Enquiry ID: ${_enquiryId ?? ''}',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: ThoonTheme.goldPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'எங்கள் நிபுணர் 24 மணி நேரத்திற்குள் உங்களை தொடர்பு கொள்வார்.\nFree site visit will be arranged.',
                          style: GoogleFonts.notoSansTamil(
                            fontSize: 13,
                            color: ThoonTheme.textMuted,
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            height: 52,
                            width: 200,
                            decoration: BoxDecoration(
                              gradient: ThoonTheme.goldGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                'BACK TO HOME',
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

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
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
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: ThoonTheme.cardBgElevated,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: ThoonTheme.goldPrimary),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: ThoonTheme.goldPrimary, size: 18),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
        ),
      ],
    );
  }
}
