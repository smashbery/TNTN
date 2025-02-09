import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(); // ✅ Correct naming
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String userRole = "customer";
  bool hasStore = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "Guest";
      userRole = prefs.getString('user_role') ?? "customer";
      hasStore = prefs.getBool('has_store') ?? false;
    });
  }

  Future<void> _createStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_store', true);
    await prefs.setString('user_role', 'owner');
    setState(() {
      hasStore = true;
      userRole = 'owner';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Store Management")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Username: $username", style: const TextStyle(fontSize: 20)),
            Text("Role: $userRole", style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),
            hasStore
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Your Store", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StoreScreen()), // ✅ No `const`
                        ),
                        child: const Text("Manage My Store"),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: _createStore,
                    child: const Text("Create a Store"),
                  ),
          ],
        ),
      ),
    );
  }
}
