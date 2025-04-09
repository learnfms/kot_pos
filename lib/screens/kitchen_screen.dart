import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../model/order.dart';
import '../resp/order_repository.dart';

class KitchenScreen extends StatefulWidget {
  @override
  _KitchenScreenState createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  late final OrderRepository _repository;
  late final WebSocketChannel _channel;
  late Future<List<Order>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _repository = OrderRepository();
    _futureOrders = _repository.fetchOrders();
    _channel = WebSocketChannel.connect(Uri.parse('ws://your-backend/orders'));
    _configureWebSocket();
  }

  void _configureWebSocket() {
    _channel.stream.listen((data) {
      final event = jsonDecode(data);
      setState(() {
        _futureOrders = _repository.fetchOrders();
      });
    }, onError: (error) => print('WebSocket error: $error'));
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitchen Display'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _futureOrders = _repository.fetchOrders();
          });
        },
        child: FutureBuilder<List<Order>>(
          future: _futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No active orders'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => OrderCard(
                order: snapshot.data![index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.id}', 
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Table ${order.tableNumber}'),
            Divider(),
            Column(
              children: order.items.map((item) => 
                Text('${item.quantity}x ${item.itemName}')
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
