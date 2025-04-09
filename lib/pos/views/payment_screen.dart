class PaymentScreen extends StatelessWidget {
  final Order order;
  
  PaymentScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Column(
        children: [
          Text('Total: ${order.total}'),
          PaymentMethodSelector(
            methods: ['Cash', 'Credit Card', 'UPI'],
            onSelected: (method) => _processPayment(method),
          ),
          ReceiptPrinter(order: order),
        ],
      ),
    );
  }

  void _processPayment(String method) {
    // Handle payment logic
  }
}
