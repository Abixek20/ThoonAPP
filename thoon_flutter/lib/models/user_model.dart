// ─────────────────────────────────────────────────────────────────────────────
// THOON – User Model
// ─────────────────────────────────────────────────────────────────────────────

enum MembershipTier { standard, silver, gold, platinum }

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final MembershipTier membershipTier;
  final int loyaltyPoints;
  final List<UserAddress> savedAddresses;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.membershipTier = MembershipTier.standard,
    this.loyaltyPoints = 0,
    this.savedAddresses = const [],
    required this.createdAt,
  });

  String get membershipLabel {
    switch (membershipTier) {
      case MembershipTier.standard:
        return 'STANDARD MEMBER';
      case MembershipTier.silver:
        return 'SILVER MEMBER';
      case MembershipTier.gold:
        return 'GOLD PRIVILEGE MEMBER';
      case MembershipTier.platinum:
        return 'PLATINUM ELITE MEMBER';
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      membershipTier: MembershipTier.values.firstWhere(
        (e) => e.name == (json['membershipTier'] as String?)?.toLowerCase(),
        orElse: () => MembershipTier.standard,
      ),
      loyaltyPoints: json['loyaltyPoints'] as int? ?? 0,
      savedAddresses: (json['savedAddresses'] as List<dynamic>? ?? [])
          .map((a) => UserAddress.fromJson(a as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class UserAddress {
  final String id;
  final String label;
  final String fullAddress;
  final String city;
  final String pinCode;
  final bool isPrimary;

  const UserAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.city,
    required this.pinCode,
    this.isPrimary = false,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      fullAddress: json['fullAddress'] as String,
      city: json['city'] as String,
      pinCode: json['pinCode'] as String,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }
}
