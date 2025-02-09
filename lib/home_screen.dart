import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawer_menu.dart'; // Import the DrawerMenu
import 'login_screen.dart';
import 'profile_screen.dart'; // Import Profile Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: const DrawerMenu(), // Add the DrawerMenu here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the Home Screen!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
              child: const Text('Manage Profile & Store'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
