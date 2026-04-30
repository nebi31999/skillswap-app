# SkillSwap - Peer Tutoring & Skill Exchange App

A comprehensive Flutter mobile application that connects students with peer tutors for skill sharing and learning sessions.

## 📱 Features

### Core Functionality
- **User Authentication**: Secure login/signup system with profile management
- **Tutor Discovery**: Browse and search available tutors by skills, location, and availability
- **Detailed Profiles**: View tutor information, ratings, reviews, and expertise areas
- **Session Requests**: Request tutoring sessions with customizable parameters
- **Favorites System**: Save preferred tutors for quick access
- **Profile Management**: Update personal information, interests, and profile picture

### Technical Features
- **State Management**: Provider pattern for efficient state handling
- **Data Persistence**: SharedPreferences for local storage
- **API Integration**: RESTful API with mock data support
- **Image Handling**: Camera and gallery integration for profile pictures
- **Responsive Design**: Material Design 3 with adaptive layouts
- **Error Handling**: Comprehensive error states and user feedback

## 🏗️ Architecture

### Project Structure
```
lib/
├── models/           # Data models (Tutor, User, Request, Review)
├── providers/        # State management (UserProvider, TutorProvider, FavoritesProvider)
├── screens/          # UI screens (Login, Home, Tutors, Profile, etc.)
├── services/         # API and storage services
├── widgets/          # Reusable UI components
└── utils/            # Utility functions and helpers
```

### Key Components

#### Data Models
- **Tutor**: Tutor information, skills, ratings, availability
- **User**: User profile, preferences, authentication data
- **Request**: Session requests with status tracking
- **Review**: Tutor reviews and ratings

#### State Management
- **UserProvider**: Authentication and user profile management
- **TutorProvider**: Tutor data, search, and filtering
- **FavoritesProvider**: Favorite tutors management

#### Services
- **ApiService**: HTTP requests and data fetching
- **StorageService**: Local data persistence with SharedPreferences

## � App Distribution

### APK File
The latest release APK is available at:
```
build/app/outputs/flutter-apk/app-release.apk
```

To install:
1. Enable "Install from Unknown Sources" in Android Settings
2. Transfer the APK to your Android device
3. Open the APK file and tap "Install"

### Build from Source
```bash
flutter build apk --release
```

## �🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.11.1)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android/iOS development environment

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd skillswap_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate JSON serialization files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable Developer Mode** (Windows)
   ```bash
   start ms-settings:developers
   ```

2. **Set up your device/emulator**
   - For Android: Set up Android emulator or connect physical device
   - For iOS: Set up iOS simulator or connect physical device

## 📦 Dependencies

### Core Dependencies
- `provider: ^6.1.2` - State management
- `http: ^1.2.1` - HTTP requests
- `shared_preferences: ^2.3.2` - Local storage
- `image_picker: ^1.1.2` - Camera/gallery access
- `cached_network_image: ^3.3.1` - Network image caching
- `permission_handler: ^11.3.1` - Device permissions

### Development Dependencies
- `json_annotation: ^4.9.0` - JSON serialization annotations
- `json_serializable: ^6.8.0` - JSON serialization code generation
- `build_runner: ^2.4.11` - Code generation runner

## 🔧 Configuration

### API Configuration
Update the `baseUrl` in `lib/services/api_service.dart` to point to your actual API endpoint:

```dart
static const String baseUrl = 'https://your-api-domain.com';
```

### Mock Data
The app includes comprehensive mock data for development and testing. Mock data is automatically used when the API is unavailable.

## 📱 App Flow

1. **Authentication**: Login → Home Dashboard
2. **Discovery**: Home → Skills → Tutor Details
3. **Interaction**: Tutor Details → Request Session
4. **Management**: Favorites → Profile Management

## 🎨 UI Components

### Key Screens
- **LoginScreen**: User authentication with form validation
- **HomeScreen**: Dashboard with quick stats and navigation
- **TutorsScreen**: Tutor listing with search and filters
- **TutorDetailsScreen**: Comprehensive tutor profile view
- **RequestSessionScreen**: Session request form
- **FavoritesScreen**: Saved tutors management
- **ProfileScreen**: User profile management

### Reusable Widgets
- **TutorCard**: Tutor listing card component
- **SkillSelector**: Skill selection widget
- **StatCard**: Dashboard statistics display

## 🔒 Security Considerations

- Input validation on all forms
- Secure password handling (mock implementation)
- Permission requests for camera/storage access
- Error handling for network requests

## 🧪 Testing

### Manual Testing Checklist
- [ ] User registration and login
- [ ] Tutor search and filtering
- [ ] Favorites functionality
- [ ] Session request submission
- [ ] Profile picture upload
- [ ] Data persistence across app restarts

### Known Limitations
- Mock authentication (no real backend)
- Image upload is simulated
- No real-time messaging
- Limited error recovery scenarios

## 🚀 Future Enhancements

### Planned Features
- Real-time chat between tutors and students
- Video calling integration
- Payment processing
- Advanced scheduling system
- Tutor verification system
- Rating and review system improvements

### Technical Improvements
- Integration with real backend API
- Push notifications
- Offline mode support
- Performance optimization
- Accessibility improvements

## � Group Members

| Name | ID |
|------|-----|
| [Husniya Mahdi] | [0557/15] |
| [Lensa Tesfaye] | [0672/15] |
| [Nebiya Jemal] | [0844/15] |
| [Ket Girma] | [0631/15] |
| [Abdiweli Mohamoud] | [5206/15] |


## �� License

This project is for educational purposes. Feel free to use and modify as needed.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

For questions or issues, please refer to the Flutter documentation or create an issue in the repository.

---

**Built with ❤️ using Flutter**
