// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutor _$TutorFromJson(Map<String, dynamic> json) => Tutor(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  profileImage: json['profileImage'] as String?,
  skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  description: json['description'] as String,
  hourlyRate: (json['hourlyRate'] as num).toDouble(),
  isAvailable: json['isAvailable'] as bool,
  location: json['location'] as String?,
  languages: (json['languages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TutorToJson(Tutor instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'profileImage': instance.profileImage,
  'skills': instance.skills,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'description': instance.description,
  'hourlyRate': instance.hourlyRate,
  'isAvailable': instance.isAvailable,
  'location': instance.location,
  'languages': instance.languages,
  'createdAt': instance.createdAt.toIso8601String(),
};
