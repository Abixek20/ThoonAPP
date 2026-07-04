import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  void _sendOtp() {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'சரியான தொலைபேசி எண்ணை உள்ளிடவும்',
            style: GoogleFonts.notoSansTamil(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: ThoonTheme.goldPrimary,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP code sent successfully (Demo: 1234)'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _verifyOtp() {
    if (_otpController.text != '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'தவறான OTP! மீண்டும் முயலவும்',
            style: GoogleFonts.notoSansTamil(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              // Brand Icon/Glow header
              Center(
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    color: ThoonTheme.cardBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: ThoonTheme.goldPrimary.withOpacity(0.5), width: 1.5),
                    boxShadow: ThoonTheme.goldGlow,
                  ),
                  child: Center(
                    child: Text(
                      'T',
                      style: GoogleFonts.outfit(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: ThoonTheme.goldPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _isOtpSent ? 'Verify OTP' : 'Let\'s Sign In',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ThoonTheme.textMain,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isOtpSent 
                    ? 'செல்லுபடியாகும் 4 இலக்க OTP குறியீட்டை உள்ளிடவும்'
                    : 'உங்கள் கட்டுமான தேவைகளுக்கு உள்நுழையவும்',
                style: GoogleFonts.notoSansTamil(
                  fontSize: 12,
                  color: ThoonTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              // Animated container sliding fields
              AnimatedCrossFade(
                firstChild: _buildPhoneInput(),
                secondChild: _buildOtpInput(),
                crossFadeState: _isOtpSent ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 500),
              ),

              const SizedBox(height: 35),
              
              // Premium Gold Gradient Action Button
              GestureDetector(
                onTap: _isLoading 
                    ? null 
                    : (_isOtpSent ? _verifyOtp : _sendOtp),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: ThoonTheme.goldGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: ThoonTheme.goldPrimary.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                        : Text(
                            _isOtpSent ? 'VERIFY & CONTINUE' : 'GET OTP VERIFICATION',
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
              
              const Spacer(),
              
              // Footer terms
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'By signing in you agree to our Terms & Conditions',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: ThoonTheme.textMuted.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MOBILE NUMBER / மொபைல் எண்',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ThoonTheme.goldPrimary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: ThoonTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '+91',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ThoonTheme.textMain,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 24,
                width: 1,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.inter(fontSize: 16, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Enter 10-digit number',
                    hintStyle: TextStyle(color: ThoonTheme.textMuted),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENTER OTP CODE / குறியீடு',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ThoonTheme.goldPrimary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: ThoonTheme.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            obscureText: true,
            style: GoogleFonts.inter(fontSize: 18, color: Colors.white, letterSpacing: 8),
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: '••••',
              hintStyle: TextStyle(color: ThoonTheme.textMuted, letterSpacing: 8),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Didn\'t receive OTP?',
              style: GoogleFonts.inter(fontSize: 12, color: ThoonTheme.textMuted),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isOtpSent = false;
                  _otpController.clear();
                });
              },
              child: Text(
                'Resend / மாற்று எண்',
                style: GoogleFonts.notoSansTamil(
                  fontSize: 12,
                  color: ThoonTheme.goldPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
