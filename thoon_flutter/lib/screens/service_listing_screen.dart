import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import 'service_detail_screen.dart';

class ServiceListingScreen extends StatefulWidget {
  final String selectedCategory;
  final bool isEmbedded;
  const ServiceListingScreen({super.key, this.selectedCategory = 'All', this.isEmbedded = false});

  @override
  State<ServiceListingScreen> createState() => _ServiceListingScreenState();
}

class _ServiceListingScreenState extends State<ServiceListingScreen> {
  late String _activeCategory;
  
  final List<String> _categories = [
    'All',
    'Masonry',
    'Electrical',
    'Plumbing',
    'Painting',
    'Tiles',
    'Carpenter',
    'Interior',
    'Construction'
  ];

  final List<Map<String, dynamic>> _allServices = [
    {
      'title': 'Premium Wall Painting',
      'category': 'Painting',
      'rating': '4.9',
      'price': '₹45 / sq.ft',
      'image': 'https://images.unsplash.com/photo-1562259949-e8e7689d7828?w=300',
      'desc': 'High-end interior wall painting using premium gold luxury emulsion. Flawless smooth finish with 3 years warranty.',
      'expert': 'Vijay Rajan (12 Years Exp)'
    },
    {
      'title': 'Luxury Bathroom Tiling',
      'category': 'Tiles',
      'rating': '4.8',
      'price': '₹8,500 Base',
      'image': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=300',
      'desc': 'Custom marble and granite tile laying with laser-guided precision alignment for zero-gap perfection.',
      'expert': 'K. Muthu (Master Tiler)'
    },
    {
      'title': 'Premium Copper Rewiring',
      'category': 'Electrical',
      'rating': '4.7',
      'price': '₹1,200 / visit',
      'image': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=300',
      'desc': 'Complete home safety inspect & copper wiring refurbishment with certified ISO heavy-duty materials.',
      'expert': 'Rajesh Kumar (Senior)'
    },
    {
      'title': 'Concrete Column Support',
      'category': 'Masonry',
      'rating': '5.0',
      'price': '₹25,000 Base',
      'image': 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=300',
      'desc': 'Structural column and arch fabrication with premium heavy aggregate and reinforcing gold steel cores.',
      'expert': 'Ganesh Acharya (Structural)'
    },
    {
      'title': 'Luxury Modern Cupboards',
      'category': 'Carpenter',
      'rating': '4.9',
      'price': '₹650 / sq.ft',
      'image': 'https://images.unsplash.com/photo-1538688525198-9b88f6f53126?w=300',
      'desc': 'Custom elegant modular wardrobes with soft-close German drawers and fine wood veneer finishes.',
      'expert': 'S. Pandian (Wood Artisan)'
    },
    {
      'title': 'Intelligent Modern Kitchen',
      'category': 'Interior',
      'rating': '5.0',
      'price': '₹1,50,000 Base',
      'image': 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=300',
      'desc': 'Premium aesthetic modern modular kitchen layouts with high-tech storage solutions and acrylic panels.',
      'expert': 'Anjali Sen (Lead Designer)'
    },
  ];

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    // Filter list based on active category
    final filteredServices = _activeCategory == 'All' 
        ? _allServices 
        : _allServices.where((s) => s['category'] == _activeCategory).toList();

    return Scaffold(
      backgroundColor: ThoonTheme.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.isEmbedded ? null : IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: ThoonTheme.goldPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: !widget.isEmbedded,
        title: Text(
          'எங்கள் சேவைகள் / Services',
          style: GoogleFonts.notoSansTamil(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sliding category chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isActive = category == _activeCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isActive,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _activeCategory = category;
                        });
                      }
                    },
                    selectedColor: ThoonTheme.goldPrimary,
                    backgroundColor: ThoonTheme.cardBg,
                    labelStyle: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? Colors.black : Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isActive ? ThoonTheme.goldPrimary : Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Main dynamic listings list
          Expanded(
            child: filteredServices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.construction_rounded, color: ThoonTheme.textMuted.withOpacity(0.4), size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'No services found in this category.',
                          style: GoogleFonts.inter(color: ThoonTheme.textMuted),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final item = filteredServices[index];
                      return _buildServiceRow(context, item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRow(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ServiceDetailScreen(service: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: 140,
        decoration: BoxDecoration(
          color: ThoonTheme.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: ThoonTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Left service thumbnail image with gold tag
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                  child: Image.network(
                    item['image'],
                    width: 120,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(width: 120, color: ThoonTheme.cardBgElevated),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ThoonTheme.goldPrimary, width: 1),
                    ),
                    child: Text(
                      item['category'],
                      style: GoogleFonts.outfit(fontSize: 9, color: ThoonTheme.goldPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            
            // Right detailed content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['expert'],
                          style: GoogleFonts.inter(fontSize: 11, color: ThoonTheme.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: ThoonTheme.goldPrimary, size: 16),
                            const SizedBox(width: 3),
                            Text(
                              item['rating'],
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Text(
                          item['price'],
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThoonTheme.goldPrimary,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
