import 'package:flutter/foundation.dart';
import '../models/tutor.dart';
import '../services/storage_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Tutor> _favorites = [];
  bool _isLoading = false;
  String? _error;

  List<Tutor> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoriteCount => _favorites.length;

  FavoritesProvider() {
    _loadFavorites();
  }

  // Load favorites from storage
  Future<void> _loadFavorites() async {
    _setLoading(true);
    try {
      _favorites = await StorageService.getFavoriteTutors();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Add tutor to favorites
  Future<bool> addToFavorites(Tutor tutor) async {
    _setLoading(true);
    try {
      await StorageService.addToFavorites(tutor);
      if (!_favorites.any((t) => t.id == tutor.id)) {
        _favorites.add(tutor);
      }
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

  // Remove tutor from favorites
  Future<bool> removeFromFavorites(String tutorId) async {
    _setLoading(true);
    try {
      await StorageService.removeFromFavorites(tutorId);
      _favorites.removeWhere((tutor) => tutor.id == tutorId);
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

  // Toggle favorite status
  Future<bool> toggleFavorite(Tutor tutor) async {
    if (isFavorite(tutor.id)) {
      return await removeFromFavorites(tutor.id);
    } else {
      return await addToFavorites(tutor);
    }
  }

  // Check if tutor is favorite
  bool isFavorite(String tutorId) {
    return _favorites.any((tutor) => tutor.id == tutorId);
  }

  // Refresh favorites
  Future<void> refresh() async {
    await _loadFavorites();
  }

  // Clear all favorites
  Future<bool> clearAllFavorites() async {
    _setLoading(true);
    try {
      await StorageService.saveFavoriteTutors([]);
      _favorites.clear();
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

  // Get favorite tutor IDs
  List<String> get favoriteIds {
    return _favorites.map((tutor) => tutor.id).toList();
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
