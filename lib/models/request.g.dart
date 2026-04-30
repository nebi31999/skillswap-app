// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TutorRequest _$TutorRequestFromJson(Map<String, dynamic> json) => TutorRequest(
  id: json['id'] as String,
  userId: json['userId'] as String,
  tutorId: json['tutorId'] as String,
  type: $enumDecode(_$RequestTypeEnumMap, json['type']),
  title: json['title'] as String,
  description: json['description'] as String,
  status: $enumDecode(_$RequestStatusEnumMap, json['status']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  scheduledFor: json['scheduledFor'] == null
      ? null
      : DateTime.parse(json['scheduledFor'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  proposedRate: (json['proposedRate'] as num?)?.toDouble(),
  location: json['location'] as String?,
  isOnline: json['isOnline'] as bool,
  duration: (json['duration'] as num?)?.toInt(),
  topics: (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$TutorRequestToJson(TutorRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'tutorId': instance.tutorId,
      'type': _$RequestTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'proposedRate': instance.proposedRate,
      'location': instance.location,
      'isOnline': instance.isOnline,
      'duration': instance.duration,
      'topics': instance.topics,
    };

const _$RequestTypeEnumMap = {
  RequestType.tutoring: 'tutoring',
  RequestType.skillExchange: 'skillExchange',
  RequestType.question: 'question',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.accepted: 'accepted',
  RequestStatus.rejected: 'rejected',
  RequestStatus.completed: 'completed',
  RequestStatus.cancelled: 'cancelled',
};
