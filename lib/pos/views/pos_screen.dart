class POSScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('POS Interface')),
      body: Column(
        children: [
          // Product Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) => ProductItem(),
            ),
          ),
          // Cart Summary
          CartSummary(),
          // Payment Options
          PaymentOptions(),
        ],
      ),
    );
  }
}
