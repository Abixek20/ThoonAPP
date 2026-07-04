import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../components/gold_label_chip.dart';

// ─────────────────────────────────────────────────────────────────────────────
// THOON – Admin Dashboard Screen (Enhanced – 5 Tabs)
// Tabs: Complaints | Services | Employees | Offers | Analytics
// ─────────────────────────────────────────────────────────────────────────────

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      appBar: AppBar(
        backgroundColor: ThoonTheme.cardBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: ThoonTheme.goldPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                gradient: ThoonTheme.goldGradient,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'ADMIN',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'THOON Control Panel',
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: ThoonTheme.goldPrimary,
          indicatorWeight: 2.5,
          labelColor: ThoonTheme.goldPrimary,
          unselectedLabelColor: ThoonTheme.textMuted,
          labelStyle: GoogleFonts.outfit(
              fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.normal),
          tabs: const [
            Tab(text: 'Complaints'),
            Tab(text: 'Orders'),
            Tab(text: 'Design'),
            Tab(text: 'Services'),
            Tab(text: 'Employees'),
            Tab(text: 'Offers'),
            Tab(text: 'Banners'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const _ComplaintsTab(),
          const _OrdersTab(),
          const _DesignTab(),
          const _ServicesTab(),
          const _EmployeesTab(),
          const _OffersTab(),
          const _BannersTab(),
          const _AnalyticsTab(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 – COMPLAINTS
// ─────────────────────────────────────────────────────────────────────────────

class _ComplaintsTab extends StatefulWidget {
  const _ComplaintsTab();

  @override
  State<_ComplaintsTab> createState() => _ComplaintsTabState();
}

class _ComplaintsTabState extends State<_ComplaintsTab> {
  String _filter = 'All';

  final List<Map<String, dynamic>> _complaints = [
    {
      'id': 'THN-998822',
      'user': 'Jonathan Davies',
      'service': 'Bathroom Tile Crack',
      'priority': 'Urgent',
      'status': 'ASSIGNED',
      'date': 'Today, 9:30 AM',
      'assigned': 'Muthu Swamy',
    },
    {
      'id': 'THN-998723',
      'user': 'Priya Sundaram',
      'service': 'Electrical Short Circuit',
      'priority': 'High',
      'status': 'IN PROGRESS',
      'date': 'Today, 8:00 AM',
      'assigned': 'Rajan Kumar',
    },
    {
      'id': 'THN-998611',
      'user': 'Vikram Nair',
      'service': 'Roof Waterproofing',
      'priority': 'Medium',
      'status': 'PENDING',
      'date': 'Yesterday',
      'assigned': 'Unassigned',
    },
    {
      'id': 'THN-998444',
      'user': 'Sundar Pichai',
      'service': 'Interior Painting',
      'priority': 'Low',
      'status': 'COMPLETED',
      'date': 'May 27',
      'assigned': 'Aravind Krishnan',
    },
    {
      'id': 'THN-998201',
      'user': 'Meena Krishnan',
      'service': 'Plumbing Leakage',
      'priority': 'High',
      'status': 'PENDING',
      'date': 'May 26',
      'assigned': 'Unassigned',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _complaints;
    return _complaints.where((c) => c['status'] == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stats bar
        Container(
          padding: const EdgeInsets.all(16),
          color: ThoonTheme.cardBg,
          child: Row(
            children: [
              _buildStatBadge('12', 'Total', ThoonTheme.goldPrimary),
              _buildStatBadge('4', 'Pending', Colors.orangeAccent),
              _buildStatBadge('5', 'Active', Colors.blueAccent),
              _buildStatBadge('3', 'Done', Colors.green),
            ],
          ),
        ),

        // Filter row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: ['All', 'PENDING', 'ASSIGNED', 'IN PROGRESS', 'COMPLETED']
                .map((f) {
              final isActive = _filter == f;
              return GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: isActive ? ThoonTheme.goldGradient : null,
                    color: isActive ? null : ThoonTheme.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? ThoonTheme.goldPrimary
                          : Colors.white.withOpacity(0.07),
                    ),
                  ),
                  child: Text(
                    f,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.black : ThoonTheme.textMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Complaints list
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filtered.length,
            itemBuilder: (context, index) {
              final c = _filtered[index];
              return _buildComplaintCard(c, context);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatBadge(String count, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
                fontSize: 10, color: ThoonTheme.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(
      Map<String, dynamic> c, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                c['id'],
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ThoonTheme.goldPrimary,
                ),
              ),
              const Spacer(),
              GoldLabelChip(
                label: c['status'],
                variant:
                    GoldLabelChip.variantForStatus(c['status']),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            c['service'],
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Customer: ${c['user']} • ${c['date']}',
            style: GoogleFonts.inter(
                fontSize: 11, color: ThoonTheme.textMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GoldLabelChip(
                label: c['priority'],
                variant:
                    GoldLabelChip.variantForPriority(c['priority']),
              ),
              const SizedBox(width: 8),
              Text(
                'Assigned to: ${c['assigned']}',
                style: GoogleFonts.inter(
                    fontSize: 11, color: ThoonTheme.textMuted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () =>
                    _showAssignDialog(context, c['id']),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ThoonTheme.goldPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: ThoonTheme.goldPrimary.withOpacity(0.4)),
                  ),
                  child: Text(
                    'Assign',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: ThoonTheme.goldPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(BuildContext context, String id) {
    String? selectedEmployee;
    final employees = [
      'Muthu Swamy',
      'Rajan Kumar',
      'Aravind Krishnan',
      'Pradeep Babu'
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) {
        return Dialog(
          backgroundColor: ThoonTheme.cardBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Assign Employee',
                  style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'Complaint: $id',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: ThoonTheme.goldPrimary),
                ),
                const SizedBox(height: 20),
                ...employees.map((e) => RadioListTile<String>(
                      title: Text(e,
                          style:
                              GoogleFonts.inter(color: Colors.white, fontSize: 14)),
                      value: e,
                      groupValue: selectedEmployee,
                      activeColor: ThoonTheme.goldPrimary,
                      onChanged: (val) => setS(() => selectedEmployee = val),
                    )),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text('Cancel',
                            style: GoogleFonts.outfit(
                                color: ThoonTheme.textMuted)),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '$selectedEmployee assigned to $id'),
                              backgroundColor: ThoonTheme.goldPrimary,
                            ),
                          );
                        },
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: ThoonTheme.goldGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'ASSIGN',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 – SERVICES
// ─────────────────────────────────────────────────────────────────────────────

class _ServicesTab extends StatelessWidget {
  const _ServicesTab();

  final List<Map<String, dynamic>> _services = const [
    {
      'title': 'Luxury Bathroom Tiling',
      'category': 'Tiles',
      'price': '₹65 / sq.ft',
      'rating': '4.9',
      'active': true,
    },
    {
      'title': 'Premium Interior Painting',
      'category': 'Painting',
      'price': '₹18 / sq.ft',
      'rating': '4.8',
      'active': true,
    },
    {
      'title': 'Complete Electrical Rewiring',
      'category': 'Electrical',
      'price': '₹12,000 / unit',
      'rating': '4.7',
      'active': true,
    },
    {
      'title': 'Waterproofing & Roofing',
      'category': 'Construction',
      'price': '₹85 / sq.ft',
      'rating': '4.9',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () => _showAddServiceDialog(context),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: ThoonTheme.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded,
                      color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'ADD NEW SERVICE',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
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
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final s = _services[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThoonTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            ThoonTheme.goldPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.construction_rounded,
                          color: ThoonTheme.goldPrimary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['title'],
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                s['category'],
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: ThoonTheme.goldPrimary),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '• ${s['price']}',
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: ThoonTheme.textMuted),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded,
                                  color: ThoonTheme.goldPrimary, size: 12),
                              Text(
                                s['rating'],
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: s['active'],
                      activeColor: ThoonTheme.goldPrimary,
                      onChanged: (val) {},
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: ThoonTheme.cardBg,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Service',
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              _dialogField('Service Title'),
              const SizedBox(height: 12),
              _dialogField('Category'),
              const SizedBox(height: 12),
              _dialogField('Price (e.g. ₹65 / sq.ft)'),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Cancel',
                          style: GoogleFonts.outfit(
                              color: ThoonTheme.textMuted)),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: ThoonTheme.goldGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'SAVE',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogField(String hint) {
    return Container(
      decoration: BoxDecoration(
        color: ThoonTheme.cardBgElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: TextField(
        style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              const TextStyle(color: ThoonTheme.textMuted, fontSize: 13),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 – EMPLOYEES
// ─────────────────────────────────────────────────────────────────────────────

class _EmployeesTab extends StatelessWidget {
  const _EmployeesTab();

  final List<Map<String, dynamic>> _employees = const [
    {
      'name': 'Muthu Swamy',
      'role': 'Senior Mason',
      'rating': '4.9',
      'jobs': 142,
      'active': 3,
      'status': 'Busy',
      'phone': '+91 98765 43210',
    },
    {
      'name': 'Rajan Kumar',
      'role': 'Master Electrician',
      'rating': '4.8',
      'jobs': 210,
      'active': 2,
      'status': 'Available',
      'phone': '+91 87654 32109',
    },
    {
      'name': 'Aravind Krishnan',
      'role': 'Certified Plumber',
      'rating': '5.0',
      'jobs': 94,
      'active': 1,
      'status': 'Available',
      'phone': '+91 76543 21098',
    },
    {
      'name': 'Pradeep Babu',
      'role': 'Interior Painter',
      'rating': '4.7',
      'jobs': 67,
      'active': 0,
      'status': 'Off Duty',
      'phone': '+91 65432 10987',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: ThoonTheme.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_add_rounded,
                      color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'ONBOARD NEW EMPLOYEE',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
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
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _employees.length,
            itemBuilder: (context, index) {
              final e = _employees[index];
              final statusColor = e['status'] == 'Available'
                  ? Colors.green
                  : e['status'] == 'Busy'
                      ? Colors.orangeAccent
                      : ThoonTheme.textMuted;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThoonTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: ThoonTheme.goldPrimary.withOpacity(0.15),
                      child: Text(
                        e['name'][0],
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ThoonTheme.goldPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['name'],
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            e['role'],
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: ThoonTheme.goldPrimary),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: ThoonTheme.goldPrimary, size: 12),
                              Text(
                                ' ${e['rating']} • ${e['jobs']} Jobs',
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: ThoonTheme.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: statusColor.withOpacity(0.5)),
                          ),
                          child: Text(
                            e['status'],
                            style: GoogleFonts.outfit(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${e['active']} Active',
                          style: GoogleFonts.inter(
                              fontSize: 10,
                              color: ThoonTheme.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 4 – OFFERS
// ─────────────────────────────────────────────────────────────────────────────

class _OffersTab extends StatelessWidget {
  const _OffersTab();

  final List<Map<String, dynamic>> _offers = const [
    {
      'title': 'Summer Tile Renovation',
      'discount': '15% OFF',
      'validity': 'Valid till June 30, 2026',
      'category': 'Tiles',
      'active': true,
    },
    {
      'title': 'Gold Member Cashback',
      'discount': '₹500 Back',
      'validity': 'Valid till May 31, 2026',
      'category': 'All Services',
      'active': true,
    },
    {
      'title': 'First-Time Customer Deal',
      'discount': '20% OFF',
      'validity': 'Valid indefinitely',
      'category': 'Masonry',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: ThoonTheme.goldGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_offer_rounded,
                      color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'CREATE NEW OFFER',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
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
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _offers.length,
            itemBuilder: (context, index) {
              final o = _offers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: o['active']
                        ? [
                            const Color(0xFF281E05),
                            ThoonTheme.cardBg,
                          ]
                        : [ThoonTheme.cardBg, ThoonTheme.cardBg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: o['active']
                        ? ThoonTheme.goldPrimary.withOpacity(0.3)
                        : Colors.white.withOpacity(0.04),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  o['discount'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: ThoonTheme.goldPrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GoldLabelChip(
                                  label: o['category'],
                                  variant: ChipVariant.muted,
                                ),
                              ],
                            ),
                            Text(
                              o['title'],
                              style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              o['validity'],
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: ThoonTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Switch(
                            value: o['active'],
                            activeColor: ThoonTheme.goldPrimary,
                            onChanged: (val) {},
                          ),
                          const SizedBox(height: 4),
                          const Icon(Icons.edit_rounded,
                              color: ThoonTheme.textMuted, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 5 – ANALYTICS
// ─────────────────────────────────────────────────────────────────────────────

class _AnalyticsTab extends StatelessWidget {
  const _AnalyticsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF281E05), Color(0xFF131313)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: ThoonTheme.goldPrimary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MONTHLY REVENUE',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: ThoonTheme.goldPrimary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹4,78,350',
                  style: GoogleFonts.outfit(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.arrow_upward_rounded,
                        color: Colors.green, size: 14),
                    Text(
                      '+18.4% from last month',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard('Site Visits', '34', Icons.home_work_rounded,
                  '+12%', Colors.blueAccent),
              _buildStatCard('Complaints', '12', Icons.report_rounded,
                  '-5%', Colors.orangeAccent),
              _buildStatCard(
                  'Services Done', '89', Icons.done_all_rounded, '+22%', Colors.green),
              _buildStatCard('New Enquiries', '7', Icons.villa_rounded,
                  '+3', ThoonTheme.goldPrimary),
            ],
          ),

          const SizedBox(height: 24),

          // Top services section
          Text(
            'TOP SERVICES THIS MONTH',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ThoonTheme.goldPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildTopServiceBar('Luxury Tiling', 0.85, '₹1,24,500'),
          _buildTopServiceBar('Interior Painting', 0.72, '₹98,200'),
          _buildTopServiceBar('Electrical Work', 0.60, '₹82,000'),
          _buildTopServiceBar('Plumbing', 0.48, '₹66,450'),
          _buildTopServiceBar('Masonry', 0.35, '₹48,000'),

          const SizedBox(height: 24),

          // Customer Satisfaction
          Text(
            'CUSTOMER SATISFACTION',
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ThoonTheme.goldPrimary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ThoonTheme.cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCSATItem('4.9 ★', 'Avg Rating'),
                _buildCSATItem('94%', 'Satisfaction'),
                _buildCSATItem('128', 'Reviews'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon,
      String change, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThoonTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                          fontSize: 11, color: ThoonTheme.textMuted),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    change,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: change.startsWith('+')
                          ? Colors.green
                          : change.startsWith('-')
                              ? Colors.redAccent
                              : ThoonTheme.goldPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopServiceBar(
      String label, double progress, String revenue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                    fontSize: 13, color: Colors.white),
              ),
              Text(
                revenue,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: ThoonTheme.goldPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  ThoonTheme.goldPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCSATItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 11, color: ThoonTheme.textMuted),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 6 – ORDERS
// ─────────────────────────────────────────────────────────────────────────────

class _OrdersTab extends StatelessWidget {
  const _OrdersTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Work Orders Management Module\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(color: ThoonTheme.textMuted, fontSize: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 7 – DESIGN CONSULTATIONS
// ─────────────────────────────────────────────────────────────────────────────

class _DesignTab extends StatelessWidget {
  const _DesignTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Design Consultations Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(color: ThoonTheme.textMuted, fontSize: 16),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 8 – BANNERS
// ─────────────────────────────────────────────────────────────────────────────

class _BannersTab extends StatelessWidget {
  const _BannersTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Promotional Banners Management\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(color: ThoonTheme.textMuted, fontSize: 16),
      ),
    );
  }
}
