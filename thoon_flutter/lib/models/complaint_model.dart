// ─────────────────────────────────────────────────────────────────────────────
// THOON – Complaint Model
// ─────────────────────────────────────────────────────────────────────────────

enum ComplaintStatus { pending, assigned, inProgress, completed, cancelled }
enum ComplaintPriority { low, medium, high, urgent }

class ComplaintModel {
  final String id;
  final String referenceId;
  final String userId;
  final String category;
  final String description;
  final ComplaintPriority priority;
  final ComplaintStatus status;
  final List<String> photoUrls;
  final bool hasVoiceNote;
  final String? voiceNoteUrl;
  final String? assignedEmployeeId;
  final String? assignedEmployeeName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ComplaintModel({
    required this.id,
    required this.referenceId,
    required this.userId,
    required this.category,
    required this.description,
    required this.priority,
    required this.status,
    this.photoUrls = const [],
    this.hasVoiceNote = false,
    this.voiceNoteUrl,
    this.assignedEmployeeId,
    this.assignedEmployeeName,
    required this.createdAt,
    this.updatedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as String,
      referenceId: json['referenceId'] as String,
      userId: json['userId'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      priority: ComplaintPriority.values.firstWhere(
        (e) => e.name == (json['priority'] as String).toLowerCase(),
        orElse: () => ComplaintPriority.medium,
      ),
      status: ComplaintStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => ComplaintStatus.pending,
      ),
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      hasVoiceNote: json['hasVoiceNote'] as bool? ?? false,
      voiceNoteUrl: json['voiceNoteUrl'] as String?,
      assignedEmployeeId: json['assignedEmployeeId'] as String?,
      assignedEmployeeName: json['assignedEmployeeName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'referenceId': referenceId,
        'userId': userId,
        'category': category,
        'description': description,
        'priority': priority.name,
        'status': status.name,
        'photoUrls': photoUrls,
        'hasVoiceNote': hasVoiceNote,
        'voiceNoteUrl': voiceNoteUrl,
        'assignedEmployeeId': assignedEmployeeId,
        'assignedEmployeeName': assignedEmployeeName,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  String get statusLabel {
    switch (status) {
      case ComplaintStatus.pending:
        return 'PENDING';
      case ComplaintStatus.assigned:
        return 'ASSIGNED';
      case ComplaintStatus.inProgress:
        return 'IN PROGRESS';
      case ComplaintStatus.completed:
        return 'COMPLETED';
      case ComplaintStatus.cancelled:
        return 'CANCELLED';
    }
  }

  String get priorityLabel => priority.name.toUpperCase();
}
