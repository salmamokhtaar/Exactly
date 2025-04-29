// ✅ Full Dark Mode Integration for Caawiye App
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/chatbot_screen.dart';
import 'screens/bookmark_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/category_landing_screen.dart';
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('darkMode') ?? false;
  runApp(CaawiyeApp(initialThemeMode: isDark ? ThemeMode.dark : ThemeMode.light));
}

class CaawiyeApp extends StatefulWidget {
  final ThemeMode initialThemeMode;
  const CaawiyeApp({super.key, required this.initialThemeMode});

  @override
  State<CaawiyeApp> createState() => _CaawiyeAppState();
}

class _CaawiyeAppState extends State<CaawiyeApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caawiye Caafimaad',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        fontFamily: 'Sans',
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        cardColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Sans',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1F1F1F),
        ),
        cardColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white70),
        colorScheme: const ColorScheme.dark(
          primary: Colors.purple,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: OnboardingScreen(onThemeToggle: toggleTheme),
    );
  }
}

class BottomNavScreen extends StatefulWidget {
  final void Function(bool) onThemeToggle;

  const BottomNavScreen({super.key, required this.onThemeToggle});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CategoryLandingScreen(),
      const BookmarkScreen(),
      const ChatbotScreen(),
      SettingsScreen(onThemeToggle: () {
        final isDark = Theme.of(context).brightness == Brightness.light;
        widget.onThemeToggle(isDark);
      }),
    ];
  }

  void _onTap(int index) => setState(() => _selectedIndex = index);

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Bogga Hore'),
    BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Keyd'),
    BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: 'Wadahadal'),
    BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Dejinta'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        selectedItemColor: Colors.purple,
        unselectedItemColor: isDark ? Colors.white70 : Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
