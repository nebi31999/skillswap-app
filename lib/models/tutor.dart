import 'package:json_annotation/json_annotation.dart';

part 'tutor.g.dart';

@JsonSerializable()
class Tutor {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final List<String> skills;
  final double rating;
  final int reviewCount;
  final String description;
  final double hourlyRate;
  final bool isAvailable;
  final String? location;
  final List<String> languages;
  final DateTime createdAt;

  const Tutor({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.skills,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.hourlyRate,
    required this.isAvailable,
    this.location,
    required this.languages,
    required this.createdAt,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) => _$TutorFromJson(json);
  Map<String, dynamic> toJson() => _$TutorToJson(this);

  Tutor copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    List<String>? skills,
    double? rating,
    int? reviewCount,
    String? description,
    double? hourlyRate,
    bool? isAvailable,
    String? location,
    List<String>? languages,
    DateTime? createdAt,
  }) {
    return Tutor(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      skills: skills ?? this.skills,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      isAvailable: isAvailable ?? this.isAvailable,
      location: location ?? this.location,
      languages: languages ?? this.languages,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Tutor && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Tutor(id: $id, name: $name, email: $email, skills: $skills, rating: $rating)';
  }
}
