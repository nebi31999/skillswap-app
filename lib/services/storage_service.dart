import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tutor.dart';
import '../models/user.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_tutors';
  static const String _userKey = 'current_user';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _registeredUsersKey = 'registered_users';

  // Save registered user with password
  static Future<bool> registerUser(User user, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_registeredUsersKey);
      Map<String, dynamic> users = {};
      
      if (usersJson != null) {
        users = Map<String, dynamic>.from(jsonDecode(usersJson));
      }
      
      // Check if email already exists
      if (users.containsKey(user.email)) {
        return false; // Email already registered
      }
      
      // Store user with password
      users[user.email] = {
        'user': user.toJson(),
        'password': password,
      };
      
      await prefs.setString(_registeredUsersKey, jsonEncode(users));
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      return true;
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  // Verify login credentials
  static Future<User?> verifyLogin(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_registeredUsersKey);
      
      if (usersJson == null) {
        return null; // No registered users
      }
      
      final users = Map<String, dynamic>.from(jsonDecode(usersJson));
      
      if (!users.containsKey(email)) {
        return null; // Email not found
      }
      
      final userData = Map<String, dynamic>.from(users[email]);
      final storedPassword = userData['password'] as String;
      
      if (storedPassword != password) {
        return null; // Wrong password
      }
      
      final user = User.fromJson(userData['user']);
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
      return user;
    } catch (e) {
      throw Exception('Failed to verify login: $e');
    }
  }

  // Check if email exists
  static Future<bool> isEmailRegistered(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_registeredUsersKey);
      
      if (usersJson == null) return false;
      
      final users = Map<String, dynamic>.from(jsonDecode(usersJson));
      return users.containsKey(email);
    } catch (e) {
      return false;
    }
  }

  // Update user password
  static Future<bool> updatePassword(String email, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_registeredUsersKey);
      
      if (usersJson == null) return false;
      
      final users = Map<String, dynamic>.from(jsonDecode(usersJson));
      
      if (!users.containsKey(email)) return false;
      
      final userData = Map<String, dynamic>.from(users[email]);
      userData['password'] = newPassword;
      users[email] = userData;
      
      await prefs.setString(_registeredUsersKey, jsonEncode(users));
      return true;
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  // Save favorite tutors
  static Future<void> saveFavoriteTutors(List<Tutor> tutors) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> tutorJsons = tutors.map((tutor) => jsonEncode(tutor.toJson())).toList();
      await prefs.setStringList(_favoritesKey, tutorJsons);
    } catch (e) {
      throw Exception('Failed to save favorite tutors: $e');
    }
  }

  // Get favorite tutors
  static Future<List<Tutor>> getFavoriteTutors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? tutorJsons = prefs.getStringList(_favoritesKey);
      
      if (tutorJsons == null) return [];
      
      return tutorJsons
          .map((json) => Tutor.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Add tutor to favorites
  static Future<void> addToFavorites(Tutor tutor) async {
    try {
      final favorites = await getFavoriteTutors();
      if (!favorites.any((t) => t.id == tutor.id)) {
        favorites.add(tutor);
        await saveFavoriteTutors(favorites);
      }
    } catch (e) {
      throw Exception('Failed to add tutor to favorites: $e');
    }
  }

  // Remove tutor from favorites
  static Future<void> removeFromFavorites(String tutorId) async {
    try {
      final favorites = await getFavoriteTutors();
      favorites.removeWhere((tutor) => tutor.id == tutorId);
      await saveFavoriteTutors(favorites);
    } catch (e) {
      throw Exception('Failed to remove tutor from favorites: $e');
    }
  }

  // Check if tutor is favorite
  static Future<bool> isFavorite(String tutorId) async {
    try {
      final favorites = await getFavoriteTutors();
      return favorites.any((tutor) => tutor.id == tutorId);
    } catch (e) {
      return false;
    }
  }

  // Save current user
  static Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_userKey, userJson);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  // Get current user
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userJson = prefs.getString(_userKey);
      
      if (userJson == null) return null;
      
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  // Clear user data
  static Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      throw Exception('Failed to clear user data: $e');
    }
  }

  // Set onboarding completed
  static Future<void> setOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingKey, true);
    } catch (e) {
      throw Exception('Failed to set onboarding status: $e');
    }
  }

  // Check if onboarding is completed
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Clear all data
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Failed to clear all data: $e');
    }
  }
}
