import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack)),
    );

    _glowAnimation = Tween<double>(begin: 0.1, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();

    // Transition to Login Screen after animation finishes
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      body: Stack(
        children: [
          // Background Golden Halo Glow
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        ThoonTheme.goldPrimary.withOpacity(0.15 * _glowAnimation.value),
                        Colors.transparent,
                      ],
                      radius: 0.7,
                    ),
                  ),
                ),
              );
            },
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Premium Architectural Emblem
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ThoonTheme.goldPrimary.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://raw.githubusercontent.com/AminYacob/assets/main/thoon_logo.png', // Falling back to web placeholder or direct asset
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholderEmblem(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Logo brand name and Tamil Tagline
                FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      Text(
                        'THOON',
                        style: GoogleFonts.outfit(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: ThoonTheme.goldPrimary,
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: ThoonTheme.goldAccent.withOpacity(0.5),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'உங்கள் கட்டுமான வேலைகளுக்கு ஒரே நம்பிக்கை',
                        style: GoogleFonts.notoSansTamil(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: ThoonTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom elegant indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textOpacity,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(ThoonTheme.goldPrimary),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'PREMIUM LUXURY BUILDER PLATFORM',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: ThoonTheme.textMuted.withOpacity(0.7),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderEmblem() {
    return Container(
      color: ThoonTheme.cardBg,
      padding: const EdgeInsets.all(25),
      child: CustomPaint(
        painter: EmblemPainter(),
      ),
    );
  }
}

// Custom CustomPainter to draw a geometric modern architectural arch emblem in gold
class EmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ThoonTheme.goldPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    final path = Path();
    
    // Draw architectural arch base + lattice lines
    path.moveTo(size.width * 0.25, size.height * 0.85);
    path.lineTo(size.width * 0.25, size.height * 0.45);
    
    path.arcToPoint(
      Offset(size.width * 0.75, size.height * 0.45),
      radius: Radius.circular(size.width * 0.25),
      clockwise: true,
    );
    
    path.lineTo(size.width * 0.75, size.height * 0.85);
    
    // Internal modern structural pillar line
    path.moveTo(size.width * 0.5, size.height * 0.85);
    path.lineTo(size.width * 0.5, size.height * 0.22);
    
    // Lattice structures
    path.moveTo(size.width * 0.25, size.height * 0.65);
    path.lineTo(size.width * 0.5, size.height * 0.45);
    path.lineTo(size.width * 0.75, size.height * 0.65);
    
    path.moveTo(size.width * 0.25, size.height * 0.45);
    path.lineTo(size.width * 0.5, size.height * 0.25);
    path.lineTo(size.width * 0.75, size.height * 0.45);

    canvas.drawPath(path, paint);

    // Draw solid gold peak dot
    final dotPaint = Paint()
      ..color = ThoonTheme.goldAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.15), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
