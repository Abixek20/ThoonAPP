import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../utils/formatters.dart';
import 'design_package_selection_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Design Consultation Submission Screen
// ─────────────────────────────────────────────────────────────────────────────

class DesignConsultationScreen extends StatefulWidget {
  const DesignConsultationScreen({super.key});

  @override
  State<DesignConsultationScreen> createState() => _DesignConsultationScreenState();
}

class _DesignConsultationScreenState extends State<DesignConsultationScreen> {
  String _selectedCategory = 'Interior Design';
  final List<String> _categories = ['Interior Design', 'Exterior Design'];

  String _selectedSubCategory = 'Residential';
  final List<String> _subCategories = ['Residential', 'Commercial', 'Industrial'];

  final TextEditingController _measurementsController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isRecording = false;
  int _recordSeconds = 0;
  bool _hasVoiceNote = false;
  
  bool _hasDwgFile = false;
  final List<bool> _photoSlots = [false, false, false];

  @override
  void dispose() {
    _measurementsController.dispose();
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

  void _proceedToPackages() {
    // Collect data and move to package selection
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DesignPackageSelectionScreen(
          category: _selectedCategory,
          subCategory: _selectedSubCategory,
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
          'Design Consultation',
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
            // ── Categories ──────────────────────────────────────────
            _buildLabel('DESIGN CATEGORY / வடிவமைப்பு வகை'),
            const SizedBox(height: 12),
            _buildDropdown(_categories, _selectedCategory, (val) {
              if (val != null) setState(() => _selectedCategory = val);
            }),

            const SizedBox(height: 24),

            _buildLabel('SUB CATEGORY / துணை வகை'),
            const SizedBox(height: 12),
            _buildDropdown(_subCategories, _selectedSubCategory, (val) {
              if (val != null) setState(() => _selectedSubCategory = val);
            }),

            const SizedBox(height: 24),

            // ── Upload DWG ────────────────────────────────────────────
            _buildLabel('UPLOAD DWG FILES / DWG கோப்புகள்'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() => _hasDwgFile = !_hasDwgFile);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: ThoonTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasDwgFile ? ThoonTheme.goldPrimary : Colors.white.withOpacity(0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _hasDwgFile ? Icons.file_present_rounded : Icons.upload_file_rounded,
                      color: _hasDwgFile ? ThoonTheme.goldPrimary : ThoonTheme.textMuted,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _hasDwgFile ? 'FloorPlan_v1.dwg attached' : 'Tap to upload DWG file',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: _hasDwgFile ? Colors.white : ThoonTheme.textMuted,
                              fontWeight: _hasDwgFile ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                          if (_hasDwgFile)
                            Text(
                              '2.4 MB',
                              style: GoogleFonts.inter(fontSize: 11, color: ThoonTheme.goldPrimary),
                            ),
                        ],
                      ),
                    ),
                    if (_hasDwgFile)
                      const Icon(Icons.check_circle_rounded, color: ThoonTheme.goldPrimary),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Upload Photos ─────────────────────────────────────────
            _buildLabel('UPLOAD PHOTOS / புகைப்படங்கள்'),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: ThoonTheme.goldPrimary, size: 28),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Photo ${index + 1}',
                                    style: GoogleFonts.inter(fontSize: 10, color: ThoonTheme.goldPrimary),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_rounded, color: ThoonTheme.goldPrimary.withOpacity(0.5), size: 28),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Add',
                                    style: GoogleFonts.inter(fontSize: 10, color: ThoonTheme.textMuted),
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

            // ── Measurements ──────────────────────────────────────────
            _buildLabel('MEASUREMENTS / அளவீடுகள் (e.g. 20x30 sqft)'),
            const SizedBox(height: 12),
            _buildTextField(_measurementsController, 'Enter area measurements...', 1),

            const SizedBox(height: 24),

            // ── Description ───────────────────────────────────────────
            _buildLabel('PROJECT DESCRIPTION / திட்ட விவரம்'),
            const SizedBox(height: 12),
            _buildTextField(_descController, 'Describe your design requirements...', 4),

            const SizedBox(height: 24),

            // ── Voice Note ────────────────────────────────────────────
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
                        color: _isRecording ? Colors.redAccent.withOpacity(0.15) : ThoonTheme.goldPrimary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isRecording ? Colors.redAccent : ThoonTheme.goldPrimary,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: _isRecording ? Colors.redAccent : ThoonTheme.goldPrimary,
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
                              : (_hasVoiceNote ? 'Voice note recorded ✓' : 'Record details via microphone'),
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _isRecording ? Colors.redAccent : Colors.white,
                          ),
                        ),
                        if (_hasVoiceNote && !_isRecording)
                          Text(
                            'Audio attachment ready',
                            style: GoogleFonts.inter(fontSize: 11, color: ThoonTheme.goldPrimary),
                          ),
                      ],
                    ),
                  ),
                  if (_hasVoiceNote && !_isRecording)
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, color: Colors.redAccent),
                      onPressed: () => setState(() => _hasVoiceNote = false),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ── Submit Button ─────────────────────────────────────────
            GestureDetector(
              onTap: _proceedToPackages,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: ThoonTheme.goldGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: ThoonTheme.goldGlow,
                ),
                child: Center(
                  child: Text(
                    'PROCEED TO PACKAGES / தொடரவும்',
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

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
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
          dropdownColor: ThoonTheme.cardBg,
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: ThoonTheme.goldPrimary),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, int maxLines) {
    return Container(
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: ThoonTheme.textMuted),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
