# SkillSwap App - Project Division Among 4 Students

## Overview
The SkillSwap Flutter app has been divided into 4 main modules, each managed by a different student. This ensures clear separation of concerns and efficient development.

---

## 👤 Student 1: Authentication & User Management
**Responsibility**: User registration, login, profile management, and authentication flow

### Key Files:
- `lib/screens/login_screen.dart`
- `lib/screens/signup_screen.dart` 
- `lib/providers/user_provider.dart`
- `lib/screens/profile_screen.dart`

### Code Highlights:

#### Login Screen (`login_screen.dart`)
```dart
// Form validation and authentication
Future<void> _login() async {
  if (_formKey.currentState!.validate()) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.login(_emailController.text.trim(), _passwordController.text);
    
    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
```

#### User Provider (`user_provider.dart`)
```dart
// Login verification with storage
Future<bool> login(String email, String password) async {
  _setLoading(true);
  try {
    final user = await StorageService.verifyLogin(email, password);
    if (user != null) {
      _user = user;
      await StorageService.saveUser(_user!);
      _error = null;
      notifyListeners();
      return true;
    }
    _error = 'Invalid email or password';
    return false;
  } catch (e) {
    _error = e.toString();
    return false;
  } finally {
    _setLoading(false);
  }
}
```

#### Profile Management (`profile_screen.dart`)
```dart
// Update user profile with tutor capabilities
Future<bool> updateProfile({
  String? name,
  String? bio,
  List<String>? teachingSkills,
  double? hourlyRate,
  // ... other fields
}) async {
  _user = _user!.copyWith(
    name: name,
    bio: bio,
    teachingSkills: teachingSkills,
    hourlyRate: hourlyRate,
    lastActive: DateTime.now(),
  );
  
  await StorageService.saveUser(_user!);
  if (_user!.canTeach) {
    await StorageService.updateUserTutorInfo(_user!);
  }
}
```

---

## 👤 Student 2: UI Components & Navigation
**Responsibility**: Main app navigation, UI components, and user interface design

### Key Files:
- `lib/main.dart`
- `lib/screens/home_screen.dart`
- `lib/screens/favorites_screen.dart`
- `lib/widgets/tutor_card.dart`
- `lib/widgets/skill_selector.dart`

### Code Highlights:

#### Main App Structure (`main.dart`)
```dart
class SkillSwapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TutorProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'SkillSwap',
        theme: AppTheme.lightTheme,
        home: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.user == null 
                ? const LoginScreen() 
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}
```

#### Home Screen Navigation (`home_screen.dart`)
```dart
// Bottom navigation with PageView controller
PageView(
  controller: _pageController,
  onPageChanged: (index) {
    setState(() {
      _currentIndex = index;
    });
  },
  children: [
    DashboardTab(onNavigateToTab: _navigateToTab),
    TutorsScreen(),
    FavoritesScreen(onNavigateToTab: _navigateToTab),
    ProfileScreen(),
  ],
)
```

#### Tutor Card Widget (`tutor_card.dart`)
```dart
class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: tutor.profileImage != null 
              ? NetworkImage(tutor.profileImage!) 
              : null,
        ),
        title: Text(tutor.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                Text('${tutor.rating} (${tutor.reviewCount} reviews)'),
              ],
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: tutor.skills.map((skill) => Chip(
                label: Text(skill),
                backgroundColor: Colors.blue.shade100,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 👤 Student 3: Tutor Management & Services
**Responsibility**: Tutor listing, search functionality, session requests, and API services

### Key Files:
- `lib/screens/tutors_screen.dart`
- `lib/screens/tutor_details_screen.dart`
- `lib/screens/request_session_screen.dart`
- `lib/providers/tutor_provider.dart`
- `lib/services/api_service.dart`

### Code Highlights:

#### Tutor Provider (`tutor_provider.dart`)
```dart
class TutorProvider extends ChangeNotifier {
  List<Tutor> _tutors = [];
  List<Tutor> get tutors => _tutors;
  bool _isLoading = false;
  
  Future<void> loadTutors({String? skill, String? search}) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _tutors = await ApiService.getTutors(skill: skill, search: search);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

#### API Service (`api_service.dart`)
```dart
// Combines mock tutors with user-created tutors
static Future<List<Tutor>> _getCombinedTutors() async {
  final mockTutors = _getMockTutors();
  final userTutors = await StorageService.getUserTutors();
  
  final allTutors = [...mockTutors, ...userTutors];
  
  // Remove duplicates
  final uniqueTutors = <Tutor>[];
  final seenIds = <String>{};
  
  for (final tutor in allTutors) {
    if (!seenIds.contains(tutor.id)) {
      seenIds.add(tutor.id);
      uniqueTutors.add(tutor);
    }
  }
  
  return uniqueTutors;
}
```

#### Tutor Details Screen (`tutor_details_screen.dart`)
```dart
// Request session functionality
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestSessionScreen(tutor: widget.tutor),
      ),
    );
  },
  icon: const Icon(Icons.calendar_today),
  label: const Text('Request Session'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
  ),
)
```

---

## 👤 Student 4: Data Models & Storage
**Responsibility**: Data structures, local storage, and data persistence

### Key Files:
- `lib/models/user.dart`
- `lib/models/tutor.dart`
- `lib/models/review.dart`
- `lib/services/storage_service.dart`

### Code Highlights:

#### User Model (`user.dart`)
```dart
@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'student', 'tutor', or 'both'
  
  // Tutor-specific fields
  final List<String> teachingSkills;
  final double? hourlyRate;
  final String? tutorDescription;
  final bool isAvailableAsTutor;
  
  // Convert User to Tutor model
  Tutor toTutor() {
    return Tutor(
      id: id,
      name: name,
      email: email,
      skills: teachingSkills.isEmpty ? interests : teachingSkills,
      rating: tutorRating,
      hourlyRate: hourlyRate ?? 25.0,
      isAvailable: isAvailableAsTutor,
    );
  }
  
  bool get canTeach => role == 'tutor' || role == 'both';
  bool get canLearn => role == 'student' || role == 'both';
}
```

#### Storage Service (`storage_service.dart`)
```dart
// Save user as tutor
static Future<void> saveUserAsTutor(User user) async {
  if (!user.canTeach) return;
  
  final prefs = await SharedPreferences.getInstance();
  final userTutorsJson = prefs.getString(_userTutorsKey);
  Map<String, dynamic> userTutors = {};
  
  if (userTutorsJson != null) {
    userTutors = Map<String, dynamic>.from(jsonDecode(userTutorsJson));
  }
  
  userTutors[user.id] = user.toJson();
  await prefs.setString(_userTutorsKey, jsonEncode(userTutors));
}

// User authentication
static Future<User?> verifyLogin(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  final usersJson = prefs.getString(_registeredUsersKey);
  
  if (usersJson == null) return null;
  
  final users = Map<String, dynamic>.from(jsonDecode(usersJson));
  final userData = users[email];
  
  if (userData != null && userData['password'] == password) {
    return User.fromJson(Map<String, dynamic>.from(userData['user']));
  }
  
  return null;
}
```

#### Tutor Model (`tutor.dart`)
```dart
@JsonSerializable()
class Tutor {
  final String id;
  final String name;
  final String email;
  final List<String> skills;
  final double rating;
  final int reviewCount;
  final String description;
  final double hourlyRate;
  final bool isAvailable;
  final String? location;
  final List<String> languages;
  final DateTime createdAt;
  
  factory Tutor.fromJson(Map<String, dynamic> json) => _$TutorFromJson(json);
  Map<String, dynamic> toJson() => _$TutorToJson(this);
}
```

---

## 🤝 Integration Points

### Student 1 ↔ Student 2
- Authentication flow connects to main navigation
- Profile updates trigger UI refreshes

### Student 2 ↔ Student 3  
- Navigation between tutor list and details
- UI components display tutor data

### Student 3 ↔ Student 4
- Tutor provider uses storage service
- API service retrieves stored tutor data

### Student 4 ↔ All Students
- Models used across all modules
- Storage service accessed by all providers

---

## 📋 Development Workflow

1. **Student 4**: Define data models and storage structure
2. **Student 1**: Implement authentication using models/storage
3. **Student 3**: Build tutor management services
4. **Student 2**: Create UI and integrate all services

Each student should:
- Follow Flutter best practices
- Write clean, documented code
- Test their components
- Coordinate integration with other team members

---

## 🚀 Final Integration

When all modules are complete:
1. Merge all branches
2. Test full app functionality
3. Fix any integration issues
4. Build final APK
5. Deploy and distribute
