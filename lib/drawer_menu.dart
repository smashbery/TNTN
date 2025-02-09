import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: const Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          // Navigation items
          _createDrawerItem(
            context: context,
            title: 'Home',
            route: '/home',
            icon: Icons.home,
          ),
          _createDrawerItem(
            context: context,
            title: 'Login',
            route: '/login',
            icon: Icons.login,
          ),
          _createDrawerItem(
            context: context,
            title: 'Weather',
            route: '/weather',
            icon: Icons.cloud,
          ),
          _createDrawerItem(
            context: context,
            title: 'Bulletin Board',
            route: '/bulletin',
            icon: Icons.message,
          ),
          _createDrawerItem(
            context: context,
            title: 'Messages',
            route: '/messages',
            icon: Icons.chat,
          ),
          _createDrawerItem(
            context: context,
            title: 'Store',
            route: '/store',
            icon: Icons.store,
          ),
          _createDrawerItem(
            context: context,
            title: 'Trade',
            route: '/trade',
            icon: Icons.swap_horiz,
          ),
          _createDrawerItem(
            context: context,
            title: 'Settings',
            route: '/settings',
            icon: Icons.settings,
          ),
          _createDrawerItem(
            context: context,
            title: 'Help',
            route: '/help',
            icon: Icons.help_outline,
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem({
    required BuildContext context,
    required String title,
    required String route,
    IconData? icon,
  }) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.blue) : null,
      title: Text(title),
      onTap: () {
        Navigator.of(context).pop(); // Close the drawer
        Navigator.pushNamed(context, route); // Navigate to the route
      },
    );
  }
}
