import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../components/push_notification_overlay.dart';
import '../components/gold_label_chip.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Complaint Screen (Enhanced)
// Supports embedded mode (inside bottom nav tab) and full-screen push mode.
// ─────────────────────────────────────────────────────────────────────────────

class ComplaintScreen extends StatefulWidget {
  /// When true, the screen is shown as a bottom-nav tab (no back button).
  final bool isEmbedded;
  const ComplaintScreen({super.key, this.isEmbedded = false});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  String _selectedService = AppConstants.complaintCategories[0];
  String _selectedPriority = 'Medium';
  bool _isRecording = false;
  int _recordSeconds = 0;
  bool _hasVoiceNote = false;
  final List<bool> _photoSlots = [false, false, false];
  final TextEditingController _descController = TextEditingController();
  bool _isLocationShared = false;
  String? _referenceId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _referenceId = AppFormatters.generateComplaintId();
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _toggleRecord() {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
        _hasVoiceNote = true;
      });
    } else {
      setState(() {
        _isRecording = true;
        _recordSeconds = 0;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() => _recordSeconds++);
        _startTimer();
      }
    });
  }

  Future<void> _submitComplaint() async {
    if (_descController.text.isEmpty && !_hasVoiceNote) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'விவரம் அல்லது குரல் குறிப்பைச் சேர்க்கவும்',
            style: GoogleFonts.notoSansTamil(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: ThoonTheme.goldPrimary,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() => _isSubmitting = false);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: ThoonTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  gradient: ThoonTheme.goldGradient,
                  shape: BoxShape.circle,
                  boxShadow: ThoonTheme.goldGlow,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.black, size: 52),
              ),
              const SizedBox(height: 24),
              Text(
                'COMPLAINT SUBMITTED',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: ThoonTheme.goldPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ThoonTheme.goldPrimary.withOpacity(0.3)),
                ),
                child: Text(
                  'Ref: $_referenceId',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: ThoonTheme.goldPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'உங்கள் புகார் வெற்றிகரமாகப் பதிவுசெய்யப்பட்டது. எங்களது பிரதிநிதி விரைவில் உங்களைத் தொடர்புகொள்வார்.',
                style: GoogleFonts.notoSansTamil(
                  fontSize: 12,
                  color: ThoonTheme.textMuted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
                  if (!widget.isEmbedded) Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      PushNotificationOverlay.show(
                        context,
                        title: 'Complaint ID: $_referenceId Registered 📋',
                        message: 'சேவை வல்லுநர் விரைவில் ஒதுக்கப்படுவார்.',
                        icon: Icons.assignment_rounded,
                      );
                    }
                  });
                },
                child: Container(
                  height: 50,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      appBar: widget.isEmbedded
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                'புதிய புகார் / File Complaint',
                style: GoogleFonts.notoSansTamil(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: ThoonTheme.goldPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'புதிய புகார் / File Complaint',
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
            // Reference ID preview
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: ThoonTheme.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: ThoonTheme.goldPrimary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.receipt_long_rounded,
                      color: ThoonTheme.goldPrimary, size: 18),
                  const SizedBox(width: 10),
                  Text(
                    'Reference: $_referenceId',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ThoonTheme.goldPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Service Category ──────────────────────────────────────────
            _buildLabel('SELECT SERVICE / சேவையின் வகை'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: ThoonTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedService,
                  isExpanded: true,
                  dropdownColor: ThoonTheme.cardBg,
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: ThoonTheme.goldPrimary),
                  items: AppConstants.complaintCategories.map((service) {
                    return DropdownMenuItem<String>(
                      value: service,
                      child: Text(service),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedService = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Priority Selector ─────────────────────────────────────────
            _buildLabel('COMPLAINT PRIORITY / அவசர நிலை'),
            const SizedBox(height: 12),
            Row(
              children: AppConstants.complaintPriorities.map((priority) {
                final isSelected = _selectedPriority == priority;
                final variant =
                    GoldLabelChip.variantForPriority(priority);
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedPriority = priority),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _chipColorFor(variant).withOpacity(0.15)
                            : ThoonTheme.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? _chipColorFor(variant)
                              : Colors.white.withOpacity(0.06),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _priorityIcon(priority),
                            color: isSelected
                                ? _chipColorFor(variant)
                                : ThoonTheme.textMuted,
                            size: 18,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            priority,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? _chipColorFor(variant)
                                  : ThoonTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // ── Multi Photo Upload Grid ────────────────────────────────────
            _buildLabel('UPLOAD PHOTOS / புகைப்படங்கள் (Up to 3)'),
            const SizedBox(height: 12),
            Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _photoSlots[index] = !_photoSlots[index];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.only(right: index < 2 ? 10 : 0),
                      height: 100,
                      decoration: BoxDecoration(
                        color: ThoonTheme.cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _photoSlots[index]
                              ? ThoonTheme.goldPrimary
                              : Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: Center(
                        child: _photoSlots[index]
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      color: ThoonTheme.goldPrimary,
                                      size: 28),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Photo ${index + 1}',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: ThoonTheme.goldPrimary),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_rounded,
                                    color: ThoonTheme.goldPrimary
                                        .withOpacity(0.5),
                                    size: 28,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Add',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: ThoonTheme.textMuted),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // ── Description ───────────────────────────────────────────────
            _buildLabel('DESCRIPTION / புகார் விவரம்'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: ThoonTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _descController,
                maxLines: 4,
                style:
                    GoogleFonts.inter(fontSize: 14, color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter complaint details here...',
                  hintStyle: TextStyle(color: ThoonTheme.textMuted),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Voice Recording ───────────────────────────────────────────
            _buildLabel('VOICE NOTE RECORDING / குரல் பதிவு'),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: ThoonTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _toggleRecord,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: _isRecording
                            ? Colors.redAccent.withOpacity(0.15)
                            : ThoonTheme.goldPrimary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isRecording
                              ? Colors.redAccent
                              : ThoonTheme.goldPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _isRecording
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: _isRecording
                            ? Colors.redAccent
                            : ThoonTheme.goldPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isRecording
                              ? 'Recording... ${AppFormatters.formatSeconds(_recordSeconds)}'
                              : (_hasVoiceNote
                                  ? 'Voice note recorded ✓'
                                  : 'Record details via microphone'),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _isRecording
                                ? Colors.redAccent
                                : Colors.white,
                          ),
                        ),
                        if (_hasVoiceNote && !_isRecording)
                          Text(
                            'Audio attachment ready',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: ThoonTheme.goldPrimary),
                          ),
                      ],
                    ),
                  ),
                  if (_hasVoiceNote && !_isRecording)
                    IconButton(
                      icon: const Icon(Icons.delete_rounded,
                          color: Colors.redAccent),
                      onPressed: () =>
                          setState(() => _hasVoiceNote = false),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Location Sharing ──────────────────────────────────────────
            _buildLabel('LIVE LOCATION / நேரடி இருப்பிடம்'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() => _isLocationShared = !_isLocationShared);
                if (_isLocationShared) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Location mapped successfully',
                        style: GoogleFonts.inter(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: _isLocationShared ? ThoonTheme.goldPrimary.withOpacity(0.1) : ThoonTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isLocationShared ? ThoonTheme.goldPrimary : Colors.white.withOpacity(0.06),
                    width: _isLocationShared ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.my_location_rounded,
                      color: _isLocationShared ? ThoonTheme.goldPrimary : ThoonTheme.textMuted,
                      size: 24,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isLocationShared ? 'Location Shared' : 'Share Current Location',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: _isLocationShared ? FontWeight.bold : FontWeight.normal,
                              color: _isLocationShared ? Colors.white : ThoonTheme.textMuted,
                            ),
                          ),
                          if (_isLocationShared) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Helps our team reach you faster',
                              style: GoogleFonts.inter(fontSize: 11, color: ThoonTheme.goldPrimary),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (_isLocationShared)
                      const Icon(Icons.check_circle_rounded, color: ThoonTheme.goldPrimary, size: 20),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ── Submit ────────────────────────────────────────────────────
            GestureDetector(
              onTap: _isSubmitting ? null : _submitComplaint,
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.black),
                          ),
                        )
                      : Text(
                          'SUBMIT COMPLAINT / புகார் அனுப்பு',
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
            const SizedBox(height: 40),
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

  Color _chipColorFor(ChipVariant variant) {
    switch (variant) {
      case ChipVariant.red:
        return Colors.redAccent;
      case ChipVariant.orange:
        return Colors.orangeAccent;
      case ChipVariant.blue:
        return Colors.blueAccent;
      default:
        return ThoonTheme.textMuted;
    }
  }

  IconData _priorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Icons.warning_rounded;
      case 'high':
        return Icons.priority_high_rounded;
      case 'medium':
        return Icons.remove_rounded;
      default:
        return Icons.arrow_downward_rounded;
    }
  }
}
