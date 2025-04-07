import 'dart:convert';
import 'package:flutter/material.dart';
import '../resp/order_repository.dart';
import '../model/order.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class KitchenScreen extends StatefulWidget {
  @override
  _KitchenScreenState createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  final OrderRepository repository = OrderRepository();
  late Future<List<Order>> futureOrders;
//   final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.5:3000')); // Replace with your backend's IP
final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.5:3000'));

  @override
  void initState() {
    super.initState();
    futureOrders = repository.fetchOrders();

    // Listen for real-time updates from the backend
    channel.stream.listen(
      (data) {
        print('Real-time update received: $data');

        // Parse WebSocket data (assuming it's JSON)
        final parsedData = jsonDecode(data);

        // Handle specific events (e.g., newOrder, orderStatusUpdated)
        if (parsedData['event'] == 'newOrder') {
          showNotification('New Order Created! Table ${parsedData['tableNumber']}');
          setState(() {
            futureOrders = repository.fetchOrders(); // Refresh orders
          });
        } else if (parsedData['event'] == 'orderStatusUpdated') {
          showNotification(
              'Order #${parsedData['orderId']} status updated to ${parsedData['status']}');
          setState(() {
            futureOrders = repository.fetchOrders(); // Refresh orders
          });
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  }

  @override
  void dispose() {
    channel.sink.close(); // Close WebSocket connection when screen is disposed
    super.dispose();
  }

  void showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kitchen Orders')),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching orders'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders available'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ListTile(
                  title: Text('Table ${order.tableNumber} - ${order.status}'),
                  subtitle:
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ...order.items.map((item) => Text('${item.itemName} x${item.quantity}')),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
