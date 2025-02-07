import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:my_project_name/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Novus Trade Network',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const CustomScaffold({required this.title, required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.blueAccent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            child: const Text('Home', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BulletinPage()),
              );
            },
            child: const Text('Bulletins', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessagesPage()),
              );
            },
            child: const Text('Messages', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WeatherPage()),
              );
            },
            child: const Text('Weather', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TradePage()),
              );
            },
            child: const Text('Trade', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StorePage()),
              );
            },
            child: const Text('Store', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: body,
          ),
          Container(
            width: 100,
            color: Colors.blue[100],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  icon: const Icon(Icons.login),
                  tooltip: 'Login',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  tooltip: 'New User',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.help),
                  tooltip: 'Help',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'The Novus Trade Network',
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blue[50],
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Weather Information', style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Weather Data Here',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Local Farmers Markets', style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Farmers Market Listings Here',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BulletinPage extends StatelessWidget {
  const BulletinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Bulletins',
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: fetchBulletins(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading bulletins'));
                } else {
                  final bulletins = snapshot.data as List<String>;
                  return ListView.builder(
                    itemCount: bulletins.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(bulletins[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to new post page or implement post creation logic
                },
                child: const Text('New Post'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to delete post page or implement deletion logic
                },
                child: const Text('Delete Post'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  // Logic for green New button
                },
                child: const Text('New', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<String>> fetchBulletins() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/bulletin'));

    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load bulletins');
    }
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Weather',
      body: const Center(
        child: Text('Weather Page Placeholder'),
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Messages',
      body: const Center(
        child: Text('Messages Page Placeholder'),
      ),
    );
  }
}

class TradePage extends StatelessWidget {
  const TradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Trade',
      body: const Center(
        child: Text('Trade Page Placeholder'),
      ),
    );
  }
}

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Store',
      body: const Center(
        child: Text('Store Page Placeholder'),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

mixin _LoginPageState implements State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return CustomScaffold(
      title: 'Login Page',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://127.0.0.1:8000/login'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'username': usernameController.text,
                    'password': passwordController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login successful')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Login failed')),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return CustomScaffold(
      title: 'Register Page',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('http://127.0.0.1:8000/register'),
                  headers: {'Content-Type': 'application/json'},
                  body: json.encode({
                    'username': usernameController.text,
                    'password': passwordController.text,
                  }),
                );

                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration successful')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration failed')),
                  );
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
