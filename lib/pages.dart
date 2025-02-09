import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: const Text('Weather'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WeatherPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Messages'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessagesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Store'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StorePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Trade'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TradePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Welcome to the Home Screen')),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Future<Map<String, dynamic>> _fetchWeatherData() async {
    final apiKey = 'b1f4d982c1123b90d430f0897e7df604'; // Replace with your API key
    final city = 'Panama City'; // Replace with your city
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

    try {
      final response = await Dio().get(apiUrl);
      return response.data;
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      throw Exception('Failed to fetch weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load weather data'));
          } else {
            final weatherData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather: ${weatherData['weather'][0]['description']}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Temperature: ${weatherData['main']['temp']} °C'),
                  Text('Humidity: ${weatherData['main']['humidity']}%'),
                  Text('Wind Speed: ${weatherData['wind']['speed']} m/s'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(child: Text('Messages Page')),
    );
  }
}

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store')),
      body: const Center(child: Text('Store Page')),
    );
  }
}

class TradePage extends StatelessWidget {
  const TradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trade')),
      body: const Center(child: Text('Trade Page')),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: const Center(child: Text('Help Page')),
    );
  }
}

class BulletinPage extends StatefulWidget {
  const BulletinPage({super.key});

  @override
  BulletinPageState createState() => BulletinPageState();
}

class BulletinPageState extends State<BulletinPage> {
  List<String> bulletins = [];
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000'));

  @override
  void initState() {
    super.initState();
    _fetchBulletins();
  }

  Future<void> _fetchBulletins() async {
    try {
      final response = await _dio.get('/bulletins');
      setState(() {
        bulletins = List<String>.from(response.data);
      });
    } catch (e) {
      debugPrint('Error fetching bulletins: $e');
    }
  }

  Future<void> _addBulletin() async {
    try {
      await _dio.post('/bulletins', data: {'text': _controller.text});
      _controller.clear();
      _fetchBulletins();
    } catch (e) {
      debugPrint('Error adding bulletin: $e');
    }
  }

  Future<void> _deleteBulletin(int index) async {
    try {
      await _dio.delete('/bulletins/$index');
      _fetchBulletins();
    } catch (e) {
      debugPrint('Error adding bulletin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bulletins')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bulletins.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(bulletins[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteBulletin(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Enter bulletin'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addBulletin,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
