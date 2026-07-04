import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'புகார் வரலாறு / History',
          style: GoogleFonts.notoSansTamil(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          // Section header active
          _buildSectionHeader('ACTIVE COMPLAINT / தற்போதைய புகார்'),
          const SizedBox(height: 12),
          _buildActiveComplaintCard(context),
          
          const SizedBox(height: 35),
          
          // Section header past
          _buildSectionHeader('PAST REQUESTS / கடந்த கால வரலாறு'),
          const SizedBox(height: 12),
          _buildPastRequestCard(
            title: 'Water Pipes Leakage Repair',
            category: 'Plumbing',
            date: 'May 12, 2026',
            cost: '₹1,500',
            status: 'COMPLETED',
            worker: 'Aravind Krishnan',
          ),
          const SizedBox(height: 16),
          _buildPastRequestCard(
            title: 'Living Room Wall Repaint',
            category: 'Painting',
            date: 'April 28, 2026',
            cost: '₹14,500',
            status: 'COMPLETED',
            worker: 'Vijay Rajan',
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: ThoonTheme.goldPrimary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildActiveComplaintCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ThoonTheme.goldPrimary.withOpacity(0.2)),
        boxShadow: ThoonTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bathroom Tile Crack Alignment',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Booking ID: THN-998822',
                    style: GoogleFonts.inter(fontSize: 12, color: ThoonTheme.textMuted),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: ThoonTheme.goldPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ThoonTheme.goldPrimary, width: 0.8),
                ),
                child: Text(
                  'IN PROGRESS',
                  style: GoogleFonts.outfit(fontSize: 9, color: ThoonTheme.goldPrimary, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          const SizedBox(height: 25),
          
          // Custom Timeline List
          _buildTimelineNode(
            title: 'Complaint Registered',
            sub: 'Yesterday, 04:30 PM',
            isDone: true,
            isLast: false,
          ),
          _buildTimelineNode(
            title: 'Admin Assigned Employee',
            sub: 'Muthu Swamy (Master Mason) Assigned',
            isDone: true,
            isLast: false,
          ),
          _buildTimelineNode(
            title: 'Employee Visit & Fix',
            sub: 'Scheduled Today, 02:00 PM',
            isDone: false,
            isLast: false,
            isActiveNow: true,
          ),
          _buildTimelineNode(
            title: 'Final Status Verification',
            sub: 'Pending visit closure',
            isDone: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required String title,
    required String sub,
    required bool isDone,
    required bool isLast,
    bool isActiveNow = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Left side dots and lines
          Column(
            children: [
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  color: isDone 
                      ? ThoonTheme.goldPrimary 
                      : (isActiveNow ? Colors.transparent : Colors.white.withOpacity(0.1)),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActiveNow ? ThoonTheme.goldPrimary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isDone 
                    ? const Icon(Icons.check, size: 12, color: Colors.black) 
                    : (isActiveNow ? Center(child: Container(height: 8, width: 8, decoration: const BoxDecoration(color: ThoonTheme.goldPrimary, shape: BoxShape.circle))) : null),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? ThoonTheme.goldPrimary : Colors.white.withOpacity(0.08),
                  ),
                )
            ],
          ),
          const SizedBox(width: 16),
          // Right content details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDone || isActiveNow ? Colors.white : ThoonTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: ThoonTheme.textMuted,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPastRequestCard({
    required String title,
    required String category,
    required String date,
    required String cost,
    required String status,
    required String worker,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: GoogleFonts.outfit(fontSize: 9, color: ThoonTheme.goldPrimary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      date,
                      style: GoogleFonts.inter(fontSize: 11, color: ThoonTheme.textMuted),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expert: $worker',
                  style: GoogleFonts.inter(fontSize: 11, color: ThoonTheme.textMuted),
                )
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                cost,
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: ThoonTheme.goldPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(fontSize: 8, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
