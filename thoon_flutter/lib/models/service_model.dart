// ─────────────────────────────────────────────────────────────────────────────
// THOON – Service Model
// ─────────────────────────────────────────────────────────────────────────────

class ServiceModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String price;
  final String? offerPrice;
  final int? discountPercent;
  final String expertName;
  final String? expertImageUrl;
  final bool isAvailable;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.offerPrice,
    this.discountPercent,
    required this.expertName,
    this.expertImageUrl,
    this.isAvailable = true,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      price: json['price'] as String,
      offerPrice: json['offerPrice'] as String?,
      discountPercent: json['discountPercent'] as int?,
      expertName: json['expertName'] as String,
      expertImageUrl: json['expertImageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'description': description,
        'imageUrl': imageUrl,
        'rating': rating,
        'reviewCount': reviewCount,
        'price': price,
        'offerPrice': offerPrice,
        'discountPercent': discountPercent,
        'expertName': expertName,
        'expertImageUrl': expertImageUrl,
        'isAvailable': isAvailable,
      };

  /// Convert from the legacy Map<String,dynamic> format used in existing screens
  Map<String, dynamic> toLegacyMap() => {
        'title': title,
        'category': category,
        'rating': rating.toStringAsFixed(1),
        'price': price,
        'image': imageUrl,
        'desc': description,
        'expert': expertName,
      };
}
