import 'package:flutter/material.dart';
import 'package:kot_pos/shared_preferences/store_data_manager.dart';

import '../model/store.dart';

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(
              child: Text(
                'Error loading store data',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Handle case where no data is available
            return Center(
              child: Text(
                'No store data available',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            // Data is available, display it
            final store = snapshot.data!;
            return Center(
              child: Text(
                'Welcome, ${store.storeName}!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }
        },
      ),
    );
  }
}
