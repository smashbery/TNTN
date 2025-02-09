import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Map<String, String>> messages = [];
  TextEditingController messageController = TextEditingController();
  String selectedCategory = 'General';
  final List<String> categories = ['General', 'Trade', 'Private'];
  String currentUser = 'You'; // Placeholder for username
  
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? messagesJson = prefs.getString('messages_list');
    if (messagesJson != null) {
      setState(() {
        messages = List<Map<String, String>>.from(json.decode(messagesJson));
      });
    }
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('messages_list', json.encode(messages));
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.insert(0, {
          'text': messageController.text,
          'timestamp': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
          'category': selectedCategory,
          'user': currentUser,
        });
        messageController.clear();
        _saveMessages();
      });
    }
  }

  void deleteMessage(int index) {
    setState(() {
      messages.removeAt(index);
      _saveMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
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
                Navigator.pushNamed(context, '/friends');
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
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: sendMessage,
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text("${messages[index]['user']}: ${messages[index]['text']}"),
                    subtitle: Text('Category: ${messages[index]['category']} | ${messages[index]['timestamp']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteMessage(index),
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
