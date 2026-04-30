import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  UserProvider() {
    _loadUser();
  }

  // Load user from storage
  Future<void> _loadUser() async {
    _setLoading(true);
    try {
      _user = await StorageService.getUser();
      _isLoggedIn = _user != null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Login user with proper authentication
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Verify login credentials
      final user = await StorageService.verifyLogin(email, password);
      
      if (user != null) {
        _user = user;
        _isLoggedIn = true;
        _error = null;
        notifyListeners();
        return true;
      } else {
        // Check if email exists
        final emailExists = await StorageService.isEmailRegistered(email);
        if (emailExists) {
          _error = 'Incorrect password';
        } else {
          _error = 'Email not registered. Please sign up first.';
        }
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Register user with proper validation
  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        // Check if email already exists
        final emailExists = await StorageService.isEmailRegistered(email);
        if (emailExists) {
          _error = 'Email already registered. Please login instead.';
          return false;
        }
        
        _user = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          email: email,
          bio: '',
          interests: [],
          location: '',
          languages: ['English'],
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );
        
        final success = await StorageService.registerUser(_user!, password);
        if (success) {
          _isLoggedIn = true;
          _error = null;
          notifyListeners();
          return true;
        } else {
          _error = 'Registration failed. Email may already exist.';
          return false;
        }
      } else {
        _error = 'Please fill in all fields';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? bio,
    String? location,
    List<String>? interests,
    List<String>? languages,
    String? profileImage,
  }) async {
    if (_user == null) return false;

    _setLoading(true);
    try {
      _user = _user!.copyWith(
        name: name,
        bio: bio,
        location: location,
        interests: interests,
        languages: languages,
        profileImage: profileImage,
        lastActive: DateTime.now(),
      );
      
      await StorageService.saveUser(_user!);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Change password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    if (_user == null) return false;
    
    _setLoading(true);
    try {
      // Verify current password
      final verifiedUser = await StorageService.verifyLogin(_user!.email, currentPassword);
      if (verifiedUser == null) {
        _error = 'Current password is incorrect';
        return false;
      }
      
      // Update password
      final success = await StorageService.updatePassword(_user!.email, newPassword);
      if (success) {
        _error = null;
        return true;
      } else {
        _error = 'Failed to update password';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logout user
  Future<void> logout() async {
    _setLoading(true);
    try {
      await StorageService.clearUser();
      _user = null;
      _isLoggedIn = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update last active timestamp
  Future<void> updateLastActive() async {
    if (_user == null) return;

    try {
      _user = _user!.copyWith(lastActive: DateTime.now());
      await StorageService.saveUser(_user!);
      notifyListeners();
    } catch (e) {
      // Silently fail for last active update
    }
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
