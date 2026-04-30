import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final String id;
  final String tutorId;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> topics;

  const Review({
    required this.id,
    required this.tutorId,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.topics,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
  Map<String, dynamic> toJson() => _$ReviewToJson(this);

  Review copyWith({
    String? id,
    String? tutorId,
    String? userId,
    String? userName,
    String? userProfileImage,
    double? rating,
    String? comment,
    DateTime? createdAt,
    List<String>? topics,
  }) {
    return Review(
      id: id ?? this.id,
      tutorId: tutorId ?? this.tutorId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      topics: topics ?? this.topics,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Review(id: $id, tutorId: $tutorId, rating: $rating, userName: $userName)';
  }
}
