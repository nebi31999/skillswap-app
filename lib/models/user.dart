import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? bio;
  final List<String> interests;
  final String? location;
  final List<String> languages;
  final DateTime createdAt;
  final DateTime lastActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.bio,
    required this.interests,
    this.location,
    required this.languages,
    required this.createdAt,
    required this.lastActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? bio,
    List<String>? interests,
    String? location,
    List<String>? languages,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
      location: location ?? this.location,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, interests: $interests)';
  }
}
