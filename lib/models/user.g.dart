// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  profileImage: json['profileImage'] as String?,
  bio: json['bio'] as String?,
  interests: (json['interests'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  location: json['location'] as String?,
  languages: (json['languages'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  lastActive: DateTime.parse(json['lastActive'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'profileImage': instance.profileImage,
  'bio': instance.bio,
  'interests': instance.interests,
  'location': instance.location,
  'languages': instance.languages,
  'createdAt': instance.createdAt.toIso8601String(),
  'lastActive': instance.lastActive.toIso8601String(),
};
