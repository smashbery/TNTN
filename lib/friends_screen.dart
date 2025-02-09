import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<String> friends = [];
  TextEditingController friendController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? friendsJson = prefs.getString('friends_list');
    if (friendsJson != null) {
      setState(() {
        friends = List<String>.from(json.decode(friendsJson));
      });
    }
  }

  Future<void> _saveFriends() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('friends_list', json.encode(friends));
  }

  void addFriend() {
    if (friendController.text.isNotEmpty) {
      setState(() {
        friends.add(friendController.text);
        friendController.clear();
        _saveFriends();
      });
    }
  }

  void removeFriend(int index) {
    setState(() {
      friends.removeAt(index);
      _saveFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Friends List')),
      drawer: Drawer(
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
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Friends List'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Messages'),
              onTap: () {
                Navigator.pushNamed(context, '/messages');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: friendController,
                    decoration: const InputDecoration(
                      hintText: 'Enter friend\'s name...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addFriend,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(friends[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeFriend(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
