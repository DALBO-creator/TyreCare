# TyreCare - Architettura e Linee Guida

## Architettura dell'Applicazione

```
┌─────────────────────────────────────┐
│          Presentation Layer         │
│  (Screens, Widgets, UI Components)  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       State Management Layer        │
│  (Provider, Riverpod, BLoC)        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Repository Layer            │
│  (Data aggregation & business logic)│
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Data Layer                  │
│  (Firebase, Local Storage, APIs)    │
└─────────────────────────────────────┘
```

## Struttura di directory consigliata

```
lib/
├── main.dart
├── constants/
│   └── app_constants.dart
├── models/
│   ├── models.dart
│   └── enums.dart
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── vehicles/
│   │   ├── vehicles_screen.dart
│   │   ├── vehicle_detail_screen.dart
│   │   └── widgets/
│   ├── booking/
│   │   ├── booking_screen.dart
│   │   ├── booking_confirmation_screen.dart
│   │   └── widgets/
│   ├── wallet/
│   │   ├── wallet_screen.dart
│   │   └── widgets/
│   └── profile/
│       ├── profile_screen.dart
│       ├── edit_profile_screen.dart
│       └── widgets/
├── services/
│   ├── firebase_service.dart
│   ├── location_service.dart
│   └── notification_service.dart
├── repositories/
│   ├── user_repository.dart
│   ├── vehicle_repository.dart
│   ├── booking_repository.dart
│   └── office_repository.dart
├── providers/
│   ├── auth_provider.dart
│   ├── vehicle_provider.dart
│   ├── booking_provider.dart
│   └── wallet_provider.dart
├── theme/
│   ├── app_theme.dart
│   └── app_colors.dart
├── utils/
│   ├── validators.dart
│   ├── formatters.dart
│   └── logger.dart
└── widgets/
    ├── custom_app_bar.dart
    ├── loading_shimmer.dart
    └── error_widget.dart
```

## Convenzioni di codice

### Naming conventions
- **File names**: `snake_case` (es. `home_screen.dart`)
- **Class names**: `PascalCase` (es. `HomeScreen`)
- **Variables/functions**: `camelCase` (es. `getUserData()`)
- **Constants**: `camelCase` (es. `defaultPadding`)
- **Private members**: Prefix con underscore (es. `_privateMethod()`)

### StatefulWidget pattern
```dart
class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize
  }

  @override
  void dispose() {
    // Cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

## Best Practices

### 1. Error Handling
```dart
try {
  final result = await repository.getData();
  // Handle success
} on FirebaseAuthException catch (e) {
  // Handle auth errors
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.message ?? 'Auth error')),
  );
} catch (e) {
  // Handle generic errors
  Logger.error('Unexpected error: $e');
}
```

### 2. Async Operations
```dart
// Use FutureBuilder
FutureBuilder<Data>(
  future: repository.fetchData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const LoadingShimmer();
    }
    if (snapshot.hasError) {
      return ErrorWidget(error: snapshot.error.toString());
    }
    return DataWidget(data: snapshot.data!);
  },
)

// Or StreamBuilder for real-time data
StreamBuilder<QuerySnapshot>(
  stream: repository.watchData(),
  builder: (context, snapshot) {
    // Similar pattern
  },
)
```

### 3. Widget Composition
```dart
// Break down large widgets into smaller ones
// Good ❌
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() => // ...
  Widget _buildBody() => // ...
}

// Better ✅
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: HomeBody(),
    );
  }
}
```

### 4. Responsive Design
```dart
// Use MediaQuery for responsive layouts
double screenWidth = MediaQuery.of(context).size.width;
bool isMobile = screenWidth < 600;

// Use Expanded/Flexible for flexible sizing
Row(
  children: [
    Expanded(child: Widget1()),
    Expanded(child: Widget2()),
  ],
)
```

## State Management Pattern (Provider)

```dart
// Model
class UserProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _user = await repository.getUser();
    } catch (e) {
      Logger.error('Error fetching user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// Usage in Widget
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading) {
          return const LoadingWidget();
        }
        return Text(userProvider.user?.name ?? 'No user');
      },
    );
  }
}
```

## Testing

### Unit Tests
```dart
void main() {
  group('UserRepository', () {
    late MockFirebaseAuth mockAuth;
    late UserRepository repository;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      repository = UserRepository(mockAuth);
    });

    test('should return user when login succeeds', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';

      // Act
      final result = await repository.login(email, password);

      // Assert
      expect(result, isA<User>());
    });
  });
}
```

### Widget Tests
```dart
void main() {
  group('HomeScreen', () {
    testWidgets('should display title', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      expect(find.text('TyreCare'), findsOneWidget);
    });
  });
}
```

## Performance Tips

1. **Use const constructors**: Riduce rebuilds
2. **Use RepaintBoundary**: Per widget costosi da ridisegnare
3. **Lazy loading**: Carica dati solo quando necessario
4. **Image caching**: Usa `Image.network` con caching
5. **List optimization**: Usa `ListView.builder` instead of `ListView`

## Debugging

### Debug print
```dart
debugPrint('Debug message: $variable');
```

### Logger utility
```dart
Logger.debug('Debug message');
Logger.info('Info message');
Logger.warning('Warning message');
Logger.error('Error message', exception);
```

### DevTools
```bash
flutter pub global activate devtools
dart devtools

# Oppure direttamente in VS Code con estensione Flutter
```

## Deployment Checklist

- [ ] Cambiare app name e package name
- [ ] Aggiornare versione e build number
- [ ] Configurare Firebase per i vari ambienti
- [ ] Rimuovere debug prints
- [ ] Testare su dispositivi reali
- [ ] Generare keystore per Android
- [ ] Configurare provisioning profiles per iOS
- [ ] Testare APK/IPA finale
- [ ] Preparare screenshot e descrizione per store
