import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String userRole = 'customer'; // Default role
  String storeDescription = "";
  List<Map<String, String>> products = [];
  List<String> workers = [];
  TextEditingController productController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController workerController = TextEditingController();
  String selectedCategory = "General";
  final List<String> categories = ["General", "Electronics", "Clothing", "Food", "Home", "Books"];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadProducts();
    _loadStoreDescription();
    _loadWorkers();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('user_role') ?? 'customer';
    });
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productsJson = prefs.getString('store_products');
    if (productsJson != null) {
      setState(() {
        products = List<Map<String, String>>.from(json.decode(productsJson));
      });
    }
  }

  Future<void> _loadStoreDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storeDescription = prefs.getString('store_description') ?? "No description available.";
    });
  }

  Future<void> _loadWorkers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      workers = (prefs.getStringList('store_workers') ?? []);
    });
  }

  void addWorker() {
    if (workerController.text.isNotEmpty) {
      setState(() {
        workers.add(workerController.text);
        workerController.clear();
        _saveWorkers();
      });
    }
  }

  void removeWorker(int index) {
    setState(() {
      workers.removeAt(index);
      _saveWorkers();
    });
  }

  Future<void> _saveWorkers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('store_workers', workers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for products...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (userRole == 'owner') ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: workerController,
                    decoration: const InputDecoration(hintText: 'Enter worker username...'),
                  ),
                  ElevatedButton(
                    onPressed: addWorker,
                    child: const Text('Add Worker'),
                  ),
                  const SizedBox(height: 10),
                  Text('Workers:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    children: List.generate(workers.length, (index) => ListTile(
                      title: Text(workers[index]),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () => removeWorker(index),
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag, size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Text(products[index]['name']!),
                      SizedBox(height: 5),
                      Text(products[index]['price']!, style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Category: ${products[index]['category']}'),
                      if (userRole == 'owner' || workers.contains(userRole))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {},
                            ),
                          ],
                        ),
                    ],
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
