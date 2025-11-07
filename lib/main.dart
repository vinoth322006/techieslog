import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/services/database_service.dart';
import 'core/services/notification_service.dart';
import 'core/providers/app_state.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/notification_provider.dart';
import 'ui/theme/modern_theme.dart';
import 'ui/screens/modern_main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize notifications
  await NotificationService().initialize();

  runApp(const TechLogApp());
}

class TechLogApp extends StatefulWidget {
  const TechLogApp({Key? key}) : super(key: key);

  @override
  State<TechLogApp> createState() => _TechLogAppState();
}

class _TechLogAppState extends State<TechLogApp> {
  late DatabaseService _db;
  late AppState _appState;
  bool _isInitialized = false;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    NotificationService.setScaffoldMessengerKey(_scaffoldMessengerKey);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    _db = DatabaseService();
    await _db.initialize();
    _appState = AppState(_db);
    
    _onInitializationComplete();
  }

  void _onInitializationComplete() {
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        if (_isInitialized) ChangeNotifierProvider.value(value: _appState),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Load theme on first build
          if (!_isInitialized && themeProvider.isDarkMode == false) {
            Future.microtask(() => themeProvider.loadTheme());
          }
          
          return MaterialApp(
            title: 'TechLog - Productivity Hub',
            theme: ModernTheme.lightTheme,
            darkTheme: ModernTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: _scaffoldMessengerKey,
            home: _isInitialized
                ? const ModernMainNavigation()
                : const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
