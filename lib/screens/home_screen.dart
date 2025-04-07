import 'package:flutter/material.dart';
import 'package:kot_pos/shared_preferences/store_data_manager.dart';
import '../model/store.dart';
import 'kitchen_screen.dart'; // Import Kitchen Screen
import 'order_management_screen.dart'; // Import Order Management Screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Store?>? future;

  @override
  void initState() {
    super.initState();
    future = StoreDataManager.loadStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: FutureBuilder<Store?>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading store data: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Handle case where no data is available
            return Center(
              child: Text(
                'No store data available',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            // Data is available, display it with navigation options
            final store = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, ${store.storeName}!',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KitchenScreen()),
                      );
                    },
                    child: const Text('Go to Kitchen Orders'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderManagementScreen()),
                      );
                    },
                    child: const Text('Manage Orders'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
