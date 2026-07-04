import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Order Status / Tracker Screen
// ─────────────────────────────────────────────────────────────────────────────

class OrderStatusScreen extends StatefulWidget {
  final String orderId;
  final String serviceTitle;

  const OrderStatusScreen({
    super.key,
    required this.orderId,
    required this.serviceTitle,
  });

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Payment Success',
      'desc': 'Payment securely processed via Razorpay.',
      'icon': Icons.payment_rounded,
      'time': 'Just now'
    },
    {
      'title': 'Work Order Generation',
      'desc': 'System is generating official work order documents.',
      'icon': Icons.description_rounded,
      'time': 'Pending'
    },
    {
      'title': 'Admin Notification',
      'desc': 'Notifying regional admin and supervisors.',
      'icon': Icons.admin_panel_settings_rounded,
      'time': 'Pending'
    },
    {
      'title': 'Employee Assignment',
      'desc': 'Assigning the best-rated expert for your service.',
      'icon': Icons.engineering_rounded,
      'time': 'Pending'
    },
    {
      'title': 'Status Updates',
      'desc': 'Live tracking of work progress.',
      'icon': Icons.track_changes_rounded,
      'time': 'Pending'
    },
  ];

  @override
  void initState() {
    super.initState();
    _simulateProgress();
  }

  void _simulateProgress() async {
    for (int i = 1; i <= 3; i++) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _currentStep = i;
          _steps[i]['time'] = 'Just now';
        });
      }
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
          icon: const Icon(Icons.close_rounded, color: ThoonTheme.goldPrimary),
          onPressed: () {
            // Pop to dashboard or root
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text(
          'Order Tracker',
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
            // Order details summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThoonTheme.cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ORDER ID: ${widget.orderId}',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ThoonTheme.goldPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.serviceTitle,
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Text(
              'LIVE TRACKING',
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ThoonTheme.textMuted,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Tracker steps
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final isCompleted = index <= _currentStep;
                final isLast = index == _steps.length - 1;
                final step = _steps[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator
                    Column(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: isCompleted ? ThoonTheme.goldPrimary.withOpacity(0.15) : ThoonTheme.cardBg,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted ? ThoonTheme.goldPrimary : Colors.white.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            step['icon'],
                            size: 16,
                            color: isCompleted ? ThoonTheme.goldPrimary : ThoonTheme.textMuted,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            height: 50,
                            width: 2,
                            color: isCompleted ? ThoonTheme.goldPrimary.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Step Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                step['title'],
                                style: GoogleFonts.outfit(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted ? Colors.white : ThoonTheme.textMuted,
                                ),
                              ),
                              Text(
                                step['time'],
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: isCompleted ? ThoonTheme.goldPrimary : ThoonTheme.textMuted.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step['desc'],
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: ThoonTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
