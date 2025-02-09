import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting timestamps

class BulletinBoardScreen extends StatefulWidget {
  const BulletinBoardScreen({super.key});

  @override
  _BulletinBoardScreenState createState() => _BulletinBoardScreenState();
}

class _BulletinBoardScreenState extends State<BulletinBoardScreen> {
  List<Map<String, String>> posts = []; // Store posts with text, timestamp, and category
  List<Map<String, String>> filteredPosts = []; // For search functionality
  TextEditingController postController = TextEditingController();
  TextEditingController searchController = TextEditingController(); // Search bar controller
  String selectedCategory = 'General'; // Default category
  final List<String> categories = ['General', 'For Sale', 'Help Wanted', 'Events'];

  @override
  void initState() {
    super.initState();
    filteredPosts = posts; // Initialize filtered posts with all posts
  }

  void addPost() {
    if (postController.text.isNotEmpty) {
      setState(() {
        posts.insert(0, {
          'text': postController.text,
          'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'category': selectedCategory,
        });
        postController.clear();
        _filterPosts(); // Reapply filter after adding a post
      });
    }
  }

  void deletePost(int index) {
    setState(() {
      posts.removeAt(index);
      _filterPosts(); // Reapply filter after deleting a post
    });
  }

  void _filterPosts() {
    setState(() {
      String query = searchController.text.toLowerCase();
      filteredPosts = posts.where((post) {
        return post['text']!.toLowerCase().contains(query) ||
               post['category']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulletin Board'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: postController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your post here...',
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
                      onPressed: addPost,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search posts...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => _filterPosts(),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(filteredPosts[index]['text']!),
                    subtitle: Text(
                      'Category: ${filteredPosts[index]['category']} | Posted on: ${filteredPosts[index]['timestamp']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deletePost(posts.indexOf(filteredPosts[index])),
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
