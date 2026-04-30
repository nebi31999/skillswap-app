import 'package:flutter/foundation.dart';
import '../models/tutor.dart';
import '../services/api_service.dart';

class TutorProvider extends ChangeNotifier {
  List<Tutor> _tutors = [];
  List<Tutor> _filteredTutors = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedSkill;

  List<Tutor> get tutors => _filteredTutors;
  List<Tutor> get allTutors => _tutors;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedSkill => _selectedSkill;

  TutorProvider() {
    loadTutors();
  }

  // Load all tutors
  Future<void> loadTutors() async {
    _setLoading(true);
    try {
      _tutors = await ApiService.getTutors();
      _applyFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Search tutors
  void searchTutors(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by skill
  void filterBySkill(String? skill) {
    _selectedSkill = skill;
    _applyFilters();
  }

  // Apply search and skill filters
  void _applyFilters() {
    _filteredTutors = _tutors.where((tutor) {
      bool matchesSearch = true;
      bool matchesSkill = true;

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        matchesSearch = tutor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                       tutor.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                       tutor.skills.any((skill) => skill.toLowerCase().contains(_searchQuery.toLowerCase()));
      }

      // Apply skill filter
      if (_selectedSkill != null && _selectedSkill!.isNotEmpty) {
        matchesSkill = tutor.skills.any((skill) => skill.toLowerCase().contains(_selectedSkill!.toLowerCase()));
      }

      return matchesSearch && matchesSkill;
    }).toList();

    notifyListeners();
  }

  // Get tutor by ID
  Tutor? getTutorById(String id) {
    try {
      return _tutors.firstWhere((tutor) => tutor.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh tutors
  Future<void> refresh() async {
    await loadTutors();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedSkill = null;
    _applyFilters();
  }

  // Get unique skills from all tutors
  List<String> getUniqueSkills() {
    final Set<String> skills = {};
    for (final tutor in _tutors) {
      skills.addAll(tutor.skills);
    }
    final skillList = skills.toList();
    skillList.sort();
    return skillList;
  }

  // Get available tutors only
  List<Tutor> get availableTutors {
    return _filteredTutors.where((tutor) => tutor.isAvailable).toList();
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
