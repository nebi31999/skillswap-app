import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

enum RequestStatus {
  pending,
  accepted,
  rejected,
  completed,
  cancelled,
}

enum RequestType {
  tutoring,
  skillExchange,
  question,
}

@JsonSerializable()
class TutorRequest {
  final String id;
  final String userId;
  final String tutorId;
  final RequestType type;
  final String title;
  final String description;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? scheduledFor;
  final DateTime? completedAt;
  final double? proposedRate;
  final String? location;
  final bool isOnline;
  final int? duration; // in minutes
  final List<String> topics;

  const TutorRequest({
    required this.id,
    required this.userId,
    required this.tutorId,
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.scheduledFor,
    this.completedAt,
    this.proposedRate,
    this.location,
    required this.isOnline,
    this.duration,
    required this.topics,
  });

  factory TutorRequest.fromJson(Map<String, dynamic> json) => _$TutorRequestFromJson(json);
  Map<String, dynamic> toJson() => _$TutorRequestToJson(this);

  TutorRequest copyWith({
    String? id,
    String? userId,
    String? tutorId,
    RequestType? type,
    String? title,
    String? description,
    RequestStatus? status,
    DateTime? createdAt,
    DateTime? scheduledFor,
    DateTime? completedAt,
    double? proposedRate,
    String? location,
    bool? isOnline,
    int? duration,
    List<String>? topics,
  }) {
    return TutorRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tutorId: tutorId ?? this.tutorId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      completedAt: completedAt ?? this.completedAt,
      proposedRate: proposedRate ?? this.proposedRate,
      location: location ?? this.location,
      isOnline: isOnline ?? this.isOnline,
      duration: duration ?? this.duration,
      topics: topics ?? this.topics,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TutorRequest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'TutorRequest(id: $id, title: $title, status: $status, type: $type)';
  }
}
