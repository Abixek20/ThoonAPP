// ─────────────────────────────────────────────────────────────────────────────
// THOON – Design Request Model
// ─────────────────────────────────────────────────────────────────────────────

class DesignRequestModel {
  final String id;
  final String designCategory; // Interior Design, Exterior Design
  final String subCategory; // Residential, Commercial, Industrial
  final List<String> dwgFilePaths;
  final List<String> photoPaths;
  final String measurements;
  final String voiceNotePath;
  final String projectDescription;
  final String packageType; // Basic, Premium
  final String status; // Submitted, Under Review, Quotation Sent, etc.
  final DateTime createdAt;

  const DesignRequestModel({
    required this.id,
    required this.designCategory,
    required this.subCategory,
    this.dwgFilePaths = const [],
    this.photoPaths = const [],
    this.measurements = '',
    this.voiceNotePath = '',
    this.projectDescription = '',
    required this.packageType,
    this.status = 'Submitted',
    required this.createdAt,
  });

  factory DesignRequestModel.fromJson(Map<String, dynamic> json) {
    return DesignRequestModel(
      id: json['id'] as String,
      designCategory: json['designCategory'] as String,
      subCategory: json['subCategory'] as String,
      dwgFilePaths: List<String>.from(json['dwgFilePaths'] ?? []),
      photoPaths: List<String>.from(json['photoPaths'] ?? []),
      measurements: json['measurements'] as String? ?? '',
      voiceNotePath: json['voiceNotePath'] as String? ?? '',
      projectDescription: json['projectDescription'] as String? ?? '',
      packageType: json['packageType'] as String,
      status: json['status'] as String? ?? 'Submitted',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'designCategory': designCategory,
        'subCategory': subCategory,
        'dwgFilePaths': dwgFilePaths,
        'photoPaths': photoPaths,
        'measurements': measurements,
        'voiceNotePath': voiceNotePath,
        'projectDescription': projectDescription,
        'packageType': packageType,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };
}
