import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'complaint_screen.dart';
import 'service_listing_screen.dart';
import 'service_detail_screen.dart';
import 'design_consultation_screen.dart';
import 'our_works_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'admin_dashboard_screen.dart';
import 'notifications_screen.dart';
import 'building_enquiry_screen.dart';
import '../components/push_notification_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';

String get currentUserName =>
    FirebaseAuth.instance.currentUser?.displayName ?? 'User';
String? get currentUserPhoto =>
    FirebaseAuth.instance.currentUser?.photoURL;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  // Notification badge count (hardcoded; wire to API later)

  final List<Widget> _views = [];

  @override
  void initState() {
    super.initState();
    _views.addAll([
      const HomeView(),
      const ServiceListingScreen(isEmbedded: true),
      const ComplaintScreen(isEmbedded: true),
      const HistoryScreen(),
      const ProfileScreen(),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          PushNotificationOverlay.show(
            context,
            title: 'Gold Privilege Active 🎖️',
            message: 'உங்கள் கட்டுமான வேலைகளுக்கு 15% தள்ளுபடி உள்ளது!',
            icon: Icons.workspace_premium_rounded,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _views,
          ),

        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ThoonTheme.cardBg,
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, 'Home'),
                _buildNavItem(1, Icons.design_services_rounded, 'Services'),
                _buildNavItem(2, Icons.add_alert_rounded, 'File'),
                _buildNavItem(3, Icons.history_edu_rounded, 'History'),
                _buildNavItem(4, Icons.person_pin_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? ThoonTheme.goldPrimary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isActive ? ThoonTheme.goldPrimary : ThoonTheme.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? ThoonTheme.goldPrimary : ThoonTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME VIEW
// ─────────────────────────────────────────────────────────────────────────────

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _bannerIndex = 0;

  final List<Map<String, dynamic>> _banners = [
    {
      'tag': 'SUMMER PREMIUM OFFERS',
      'title': 'Swimming Pool Construction',
      'sub': 'Build your luxury private pool this summer',
      'cta': 'VIEW DETAILS',
      'service': {
        'title': 'Swimming Pool Construction',
        'category': 'Construction',
        'rating': '4.9',
        'price': 'From ₹5L',
        'image': 'https://images.unsplash.com/photo-1576013551627-11971f3fc8af?w=800',
        'desc': 'Complete end-to-end luxury swimming pool construction with premium materials and warranty.',
        'expert': 'Thoon Aqua Experts',
      }
    },
    {
      'tag': 'NEW BUILDING SEASON',
      'title': 'Garden & Landscaping',
      'sub': 'Thottam Concept design and implementation',
      'cta': 'VIEW DETAILS',
      'service': {
        'title': 'Garden & Landscaping',
        'category': 'Garden / Landscape Services',
        'rating': '4.8',
        'price': 'From ₹50k',
        'image': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=800',
        'desc': 'Transform your outdoor space with our customized Thottam concepts and landscaping.',
        'expert': 'GreenScapes Team',
      }
    },
    {
      'tag': 'EXCLUSIVE GOLD MEMBER',
      'title': 'Special Offers',
      'sub': '15% Off on Mason Work (Kothanar)',
      'cta': 'VIEW DETAILS',
      'service': {
        'title': 'Mason Work (Kothanar)',
        'category': 'Mason Work (Kothanar)',
        'rating': '5.0',
        'price': 'From ₹1,500/day',
        'image': 'https://images.unsplash.com/photo-1504307651254-35680f356f27?w=800',
        'desc': 'Expert masonry services for new constructions, walls, and repairs.',
        'expert': 'Rajesh Builder',
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 64),

          // ── Header ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminDashboardScreen()),
                        );
                      },
                      child: Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: ThoonTheme.goldPrimary, width: 2),
                          image:  DecorationImage(
                            image: NetworkImage(currentUserPhoto ??
                                'https://i.pravatar.cc/150?img=33'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'வணக்கம் / Welcome,',
                          style: GoogleFonts.notoSansTamil(
                            fontSize: 12,
                            color: ThoonTheme.textMuted,
                          ),
                        ),
                        Text(
                          currentUserName,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ThoonTheme.textMain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Notification Bell with badge
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const NotificationsScreen()),
                    );
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: ThoonTheme.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.notifications_none_rounded,
                            color: ThoonTheme.goldPrimary),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              gradient: ThoonTheme.goldGradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: ThoonTheme.darkBg, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                '2',
                                style: GoogleFonts.outfit(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
          ),

          const SizedBox(height: 16),

          // ── Location Row ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: ThoonTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: ThoonTheme.goldPrimary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Nungambakkam, Chennai',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: ThoonTheme.goldPrimary, size: 18),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // ── Promotional Banners Slider ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! < 0) {
                  setState(() {
                    _bannerIndex = (_bannerIndex + 1) % _banners.length;
                  });
                } else {
                  setState(() {
                    _bannerIndex =
                        (_bannerIndex - 1 + _banners.length) % _banners.length;
                  });
                }
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: GestureDetector(
                  onTap: () {
                    final service = _banners[_bannerIndex]['service'] as Map<String, dynamic>?;
                    if (service != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(service: service),
                        ),
                      );
                    }
                  },
                  child: _buildBannerCard(_banners[_bannerIndex], key: ValueKey(_bannerIndex)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Banner dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 4,
                width: _bannerIndex == index ? 20 : 6,
                decoration: BoxDecoration(
                  color: _bannerIndex == index
                      ? ThoonTheme.goldPrimary
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // ── Building Enquiry CTA Card ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const BuildingEnquiryScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      ThoonTheme.goldDark.withOpacity(0.8),
                      const Color(0xFF1A1200),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                      color: ThoonTheme.goldPrimary.withOpacity(0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: ThoonTheme.goldPrimary.withOpacity(0.08),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: ThoonTheme.goldPrimary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'NEW CONSTRUCTION',
                              style: GoogleFonts.outfit(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: ThoonTheme.goldPrimary,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Planning to build?\nGet a FREE quote!',
                            style: GoogleFonts.outfit(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'New Building Enquiry',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: ThoonTheme.goldPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: ThoonTheme.goldPrimary, size: 14),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: ThoonTheme.goldPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: ThoonTheme.goldPrimary.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.villa_rounded,
                          color: ThoonTheme.goldPrimary, size: 36),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ── Quick Links ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DesignConsultationScreen(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThoonTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ThoonTheme.goldPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.design_services_rounded, color: ThoonTheme.goldPrimary, size: 24),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Design\nConsultation',
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OurWorksScreen(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ThoonTheme.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ThoonTheme.goldPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.photo_library_rounded, color: ThoonTheme.goldPrimary, size: 24),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Our\nWorks',
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ── Service Grid Categories ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'உடனடி சேவைகள் / Fast Booking',
                  style: GoogleFonts.notoSansTamil(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            const ServiceListingScreen(selectedCategory: 'All'),
                      ),
                    );
                  },
                  child: Text(
                    'See All',
                    style: GoogleFonts.outfit(
                        color: ThoonTheme.goldPrimary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildServiceCategory(context, 'Mason Work (Kothanar)', Icons.foundation_rounded),
                _buildServiceCategory(context, 'Swimming Pool', Icons.pool_rounded),
                _buildServiceCategory(context, 'Garden / Landscape', Icons.park_rounded),
                _buildServiceCategory(context, 'House Cleaning', Icons.cleaning_services_rounded),
                _buildServiceCategory(context, 'Renovation', Icons.home_repair_service_rounded),
                _buildServiceCategory(context, 'Photo Frame', Icons.image_rounded),
                _buildServiceCategory(context, 'Interior', Icons.chair_rounded),
                _buildServiceCategory(context, 'Construction', Icons.business_rounded),
              ],
            ),
          ),

          const SizedBox(height: 35),

          // ── Top Rated Experts ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'நம்பகமான வல்லுநர்கள் / Top Rated Experts',
              style: GoogleFonts.notoSansTamil(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 190,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20, right: 20),
              children: [
                _buildExpertCard(
                  name: 'Rajesh Kumar',
                  role: 'Master Mason',
                  rating: '4.9',
                  jobs: '142',
                  imageUrl:
                      'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?w=150',
                ),
                _buildExpertCard(
                  name: 'Muthu Swamy',
                  role: 'Senior Electrician',
                  rating: '4.8',
                  jobs: '210',
                  imageUrl:
                      'https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=150',
                ),
                _buildExpertCard(
                  name: 'Aravind Krishnan',
                  role: 'Premium Plumber',
                  rating: '5.0',
                  jobs: '94',
                  imageUrl:
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                ),
              ],
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildBannerCard(Map<String, dynamic> banner, {Key? key}) {
    return Container(
      key: key,
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF281E05), Color(0xFF131313)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border:
            Border.all(color: ThoonTheme.goldPrimary.withOpacity(0.25)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.15,
              child: Icon(Icons.architecture_rounded,
                  size: 200, color: ThoonTheme.goldPrimary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner['tag']!,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ThoonTheme.goldPrimary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner['title']!,
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  banner['sub']!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: ThoonTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: ThoonTheme.goldGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    banner['cta']!,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCategory(
      BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ServiceListingScreen(selectedCategory: title),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ThoonTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.04)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(icon, color: ThoonTheme.goldPrimary, size: 28),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: ThoonTheme.textMain,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildExpertCard({
    required String name,
    required String role,
    required String rating,
    required String jobs,
    required String imageUrl,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: ThoonTheme.cardBgElevated),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  role,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: ThoonTheme.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: ThoonTheme.goldPrimary, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      rating,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$jobs Jobs',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: ThoonTheme.goldPrimary,
                        fontWeight: FontWeight.w600,
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
