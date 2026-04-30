import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tutor.dart';
import '../models/review.dart';

class ApiService {
  static const String baseUrl = 'https://api.skillswap.com'; // Replace with actual API URL
  static const String tutorsEndpoint = '/tutors';
  static const String reviewsEndpoint = '/reviews';

  // Fetch all tutors
  static Future<List<Tutor>> getTutors({String? skill, String? search}) async {
    try {
      Map<String, String> queryParams = {};
      if (skill != null) queryParams['skill'] = skill;
      if (search != null) queryParams['search'] = search;

      Uri uri = Uri.parse('$baseUrl$tutorsEndpoint').replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Tutor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tutors: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockTutors();
    }
  }

  // Fetch tutor by ID
  static Future<Tutor> getTutorById(String tutorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$tutorsEndpoint/$tutorId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Tutor.fromJson(data);
      } else {
        throw Exception('Failed to load tutor: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock data
      final mockTutors = _getMockTutors();
      final tutor = mockTutors.where((t) => t.id == tutorId).firstOrNull;
      if (tutor != null) {
        return tutor;
      }
      throw Exception('Tutor not found');
    }
  }

  // Fetch reviews for a tutor
  static Future<List<Review>> getTutorReviews(String tutorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$reviewsEndpoint? tutorId=$tutorId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Review.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to mock data
      return _getMockReviews(tutorId);
    }
  }

  // Mock data for development
  static List<Tutor> _getMockTutors() {
    return [
      Tutor(
        id: '1',
        name: 'Sarah Johnson',
        email: 'sarah.j@example.com',
        profileImage: 'https://picsum.photos/seed/sarah/200/200.jpg',
        skills: ['Mathematics', 'Calculus', 'Algebra'],
        rating: 4.8,
        reviewCount: 45,
        description: 'Experienced math tutor with 5+ years of teaching experience. Specializing in high school and college level mathematics.',
        hourlyRate: 35.0,
        isAvailable: true,
        location: 'New York, NY',
        languages: ['English', 'Spanish'],
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      Tutor(
        id: '2',
        name: 'Michael Chen',
        email: 'michael.c@example.com',
        profileImage: 'https://picsum.photos/seed/michael/200/200.jpg',
        skills: ['Programming', 'Python', 'JavaScript', 'React'],
        rating: 4.9,
        reviewCount: 67,
        description: 'Full-stack developer passionate about teaching programming. Expert in web development and data science.',
        hourlyRate: 45.0,
        isAvailable: true,
        location: 'San Francisco, CA',
        languages: ['English', 'Mandarin'],
        createdAt: DateTime.now().subtract(const Duration(days: 400)),
      ),
      Tutor(
        id: '3',
        name: 'Emily Rodriguez',
        email: 'emily.r@example.com',
        profileImage: 'https://picsum.photos/seed/emily/200/200.jpg',
        skills: ['Physics', 'Chemistry', 'Biology'],
        rating: 4.7,
        reviewCount: 38,
        description: 'Science tutor with background in biomedical engineering. Making complex concepts easy to understand.',
        hourlyRate: 40.0,
        isAvailable: false,
        location: 'Austin, TX',
        languages: ['English', 'Spanish'],
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      ),
      Tutor(
        id: '4',
        name: 'David Kim',
        email: 'david.k@example.com',
        profileImage: 'https://picsum.photos/seed/david/200/200.jpg',
        skills: ['English', 'Writing', 'Literature'],
        rating: 4.6,
        reviewCount: 52,
        description: 'Professional writer and editor helping students improve their writing skills and literary analysis.',
        hourlyRate: 30.0,
        isAvailable: true,
        location: 'Seattle, WA',
        languages: ['English', 'Korean'],
        createdAt: DateTime.now().subtract(const Duration(days: 500)),
      ),
      Tutor(
        id: '5',
        name: 'Lisa Thompson',
        email: 'lisa.t@example.com',
        profileImage: 'https://picsum.photos/seed/lisa/200/200.jpg',
        skills: ['Music', 'Piano', 'Music Theory'],
        rating: 4.9,
        reviewCount: 29,
        description: 'Concert pianist and music teacher. Offering lessons for beginners to advanced students.',
        hourlyRate: 50.0,
        isAvailable: true,
        location: 'Boston, MA',
        languages: ['English', 'French'],
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
    ];
  }

  static List<Review> _getMockReviews(String tutorId) {
    return [
      Review(
        id: '1',
        tutorId: tutorId,
        userId: 'user1',
        userName: 'John Doe',
        userProfileImage: 'https://picsum.photos/seed/user1/50/50.jpg',
        rating: 5.0,
        comment: 'Excellent tutor! Very patient and explains concepts clearly.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        topics: ['Mathematics', 'Calculus'],
      ),
      Review(
        id: '2',
        tutorId: tutorId,
        userId: 'user2',
        userName: 'Jane Smith',
        userProfileImage: 'https://picsum.photos/seed/user2/50/50.jpg',
        rating: 4.0,
        comment: 'Good teaching style, but sessions could be more structured.',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        topics: ['Algebra'],
      ),
      Review(
        id: '3',
        tutorId: tutorId,
        userId: 'user3',
        userName: 'Mike Johnson',
        userProfileImage: 'https://picsum.photos/seed/user3/50/50.jpg',
        rating: 5.0,
        comment: 'Helped me improve my grades significantly. Highly recommend!',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        topics: ['Mathematics'],
      ),
    ];
  }
}
