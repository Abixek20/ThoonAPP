// ─────────────────────────────────────────────────────────────────────────────
// THOON – Booking Model
// ─────────────────────────────────────────────────────────────────────────────

enum BookingStatus { pending, confirmed, visited, converted, cancelled }
enum BookingType { siteVisit, serviceBooking, buildingEnquiry }

class BookingModel {
  final String id;
  final String referenceId;
  final String userId;
  final String serviceId;
  final String serviceTitle;
  final BookingType type;
  final BookingStatus status;
  final DateTime scheduledDate;
  final String timeSlot;
  final String address;
  final double siteVisitFee;
  final bool siteVisitFeePaid;
  final String? razorpayPaymentId;
  final double? finalProjectCost;
  final bool isSiteFeeCredited;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.referenceId,
    required this.userId,
    required this.serviceId,
    required this.serviceTitle,
    required this.type,
    required this.status,
    required this.scheduledDate,
    required this.timeSlot,
    required this.address,
    required this.siteVisitFee,
    this.siteVisitFeePaid = false,
    this.razorpayPaymentId,
    this.finalProjectCost,
    this.isSiteFeeCredited = false,
    required this.createdAt,
  });

  /// Business rule: site visit fee credited against final project cost
  double get remainingBalance {
    if (finalProjectCost == null) return 0;
    if (isSiteFeeCredited) {
      return finalProjectCost! - siteVisitFee;
    }
    return finalProjectCost!;
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      referenceId: json['referenceId'] as String,
      userId: json['userId'] as String,
      serviceId: json['serviceId'] as String,
      serviceTitle: json['serviceTitle'] as String,
      type: BookingType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BookingType.siteVisit,
      ),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      timeSlot: json['timeSlot'] as String,
      address: json['address'] as String,
      siteVisitFee: (json['siteVisitFee'] as num).toDouble(),
      siteVisitFeePaid: json['siteVisitFeePaid'] as bool? ?? false,
      razorpayPaymentId: json['razorpayPaymentId'] as String?,
      finalProjectCost: (json['finalProjectCost'] as num?)?.toDouble(),
      isSiteFeeCredited: json['isSiteFeeCredited'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
