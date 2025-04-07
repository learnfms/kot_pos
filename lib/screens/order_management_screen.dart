import 'package:flutter/material.dart';
import '../resp/order_repository.dart';
import '../model/order.dart';

class OrderManagementScreen extends StatefulWidget {
  @override
  _OrderManagementScreenState createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  final OrderRepository repository = OrderRepository();
  late Future<List<Order>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = repository.fetchOrders();
  }

  void updateStatus(int orderId, String status) async {
    try {
      await repository.updateOrderStatus(orderId, status);
      setState(() {
        futureOrders = repository.fetchOrders(); // Refresh orders after update
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Orders')),
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
                  trailing: DropdownButton<String>(
                    value: order.status,
                    items: ['New', 'Preparing', 'Ready', 'Delivered']
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) updateStatus(order.id, newStatus);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
