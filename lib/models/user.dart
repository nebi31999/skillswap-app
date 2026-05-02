import 'package:json_annotation/json_annotation.dart';
import 'tutor.dart';

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
  final String role; // 'student', 'tutor', or 'both'
  
  // Tutor-specific fields (for users who are also tutors)
  final List<String> teachingSkills;
  final double? hourlyRate;
  final String? tutorDescription;
  final bool isAvailableAsTutor;
  final double tutorRating;
  final int tutorReviewCount;

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
    this.role = 'student',
    this.teachingSkills = const [],
    this.hourlyRate,
    this.tutorDescription,
    this.isAvailableAsTutor = false,
    this.tutorRating = 0.0,
    this.tutorReviewCount = 0,
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
    String? role,
    List<String>? teachingSkills,
    double? hourlyRate,
    String? tutorDescription,
    bool? isAvailableAsTutor,
    double? tutorRating,
    int? tutorReviewCount,
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
      role: role ?? this.role,
      teachingSkills: teachingSkills ?? this.teachingSkills,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      tutorDescription: tutorDescription ?? this.tutorDescription,
      isAvailableAsTutor: isAvailableAsTutor ?? this.isAvailableAsTutor,
      tutorRating: tutorRating ?? this.tutorRating,
      tutorReviewCount: tutorReviewCount ?? this.tutorReviewCount,
    );
  }

  // Convert User to Tutor model (for displaying in tutor list)
  Tutor toTutor() {
    return Tutor(
      id: id,
      name: name,
      email: email,
      profileImage: profileImage,
      skills: teachingSkills.isEmpty ? interests : teachingSkills,
      rating: tutorRating,
      reviewCount: tutorReviewCount,
      description: tutorDescription ?? bio ?? 'Tutor specializing in ${teachingSkills.isEmpty ? interests.join(", ") : teachingSkills.join(", ")}',
      hourlyRate: hourlyRate ?? 25.0,
      isAvailable: isAvailableAsTutor,
      location: location,
      languages: languages,
      createdAt: createdAt,
    );
  }

  // Check if user can act as tutor
  bool get canTeach => role == 'tutor' || role == 'both';
  
  // Check if user can act as student
  bool get canLearn => role == 'student' || role == 'both';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role, interests: $interests)';
  }
}
