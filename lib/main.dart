import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tntn/login_screen.dart' as login;
import 'package:tntn/register_screen.dart' as register;
import 'package:tntn/home_screen.dart';
import 'package:tntn/weather_screen.dart';
import 'package:tntn/bulletin_board_screen.dart';
import 'package:tntn/messages_screen.dart';
import 'package:tntn/store_screen.dart';
import 'package:tntn/trade_screen.dart';
import 'package:tntn/settings_screen.dart';
import 'package:tntn/help_screen.dart';
import 'package:tntn/friends_screen.dart';
import 'package:tntn/profile_screen.dart'; // Ensure ProfileScreen is imported

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => login.LoginScreen(),
        '/register': (context) => register.RegisterScreen(),
        '/friends': (context) => FriendsScreen(),
        '/profile': (context) => ProfileScreen(),  // ✅ Removed `const`
        '/home': (context) => HomeScreen(),
        '/weather': (context) => WeatherScreen(),
        '/bulletin': (context) => BulletinBoardScreen(),
        '/messages': (context) => MessagesScreen(),
        '/store': (context) => StoreScreen(),
        '/trade': (context) => TradeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/help': (context) => HelpScreen(),
      },
    );
  }
}
