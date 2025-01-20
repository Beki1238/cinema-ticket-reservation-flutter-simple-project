import 'package:flutter/material.dart';
import 'utils/session_manager.dart';
import 'widgets/navbar.dart';
import 'screens/home.dart';
import 'screens/movies.dart';
import 'screens/coming.dart';
import 'screens/now_playing.dart';
import 'screens/profile.dart';
import 'screens/login.dart';
import 'screens/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cinema App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.red),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.red),
          bodyMedium: TextStyle(color: Colors.red),
        ),
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const BottomNav(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/movies': (context) => const MoviesPage(),
      },
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  bool isLoggedIn = false;
  String? userName;
  String? userEmail;

  final pages = [
    const HomeScreen(),
    const MoviesPage(),
    const NowPlayingScreen(),
    const ComingSoonScreen(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final loggedIn = await SessionManager.isLoggedIn();
    if (loggedIn) {
      final user = await SessionManager.getUser();
      setState(() {
        isLoggedIn = true;
        userName = user['userName'];
        userEmail = user['userEmail'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Triangle Cinema", style: TextStyle(color: Colors.red)),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            itemBuilder: (BuildContext context) {
              return isLoggedIn
                  ? {'Profile', 'Settings', 'Log Out'}
                      .map((String choice) => PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice, style: const TextStyle(color: Colors.red)),
                          ))
                      .toList()
                  : {'Login', 'Settings'}
                      .map((String choice) => PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice, style: const TextStyle(color: Colors.red)),
                          ))
                      .toList();
            },
            onSelected: (value) {
              if (value == 'Log Out') {
                _handleLogout(context);
              } else if (value == 'Login') {
                Navigator.pushNamed(context, '/login').then((_) {
                  _checkLoginStatus(); // Re-check login status after login
                });
              }
            },
          ),
        ],
      ),
      drawer: NavBar(
        isLoggedIn: isLoggedIn,
        userName: userName,
        userEmail: userEmail,
        onLogout: () => _handleLogout(context),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red.withOpacity(0.7),
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.now_widgets), label: "Now Playing"),
          BottomNavigationBarItem(icon: Icon(Icons.upcoming), label: "Coming"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: Text("Are you sure you want to log out, ${userName ?? 'User'}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel logout
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await SessionManager.clearSession();
                setState(() {
                  isLoggedIn = false;
                  userName = null;
                  userEmail = null;
                });
              },
              child: const Text("Log Out", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
