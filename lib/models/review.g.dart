// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  id: json['id'] as String,
  tutorId: json['tutorId'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  userProfileImage: json['userProfileImage'] as String?,
  rating: (json['rating'] as num).toDouble(),
  comment: json['comment'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  topics: (json['topics'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'id': instance.id,
  'tutorId': instance.tutorId,
  'userId': instance.userId,
  'userName': instance.userName,
  'userProfileImage': instance.userProfileImage,
  'rating': instance.rating,
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
  'topics': instance.topics,
};
