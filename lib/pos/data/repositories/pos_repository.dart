class POSRepository {
  final POSDatabase _db;

  POSRepository(this._db);

  // Product Management
  Future<void> addProduct(Product product) => _db.into(_db.products).insert(product);
  
  Stream<List<Product>> watchProducts() => _db.select(_db.products).watch();

  // Order Management
  Future<int> createOrder(Order order, List<OrderItem> items) async {
    return _db.transaction(() async {
      final orderId = await _db.into(_db.orders).insert(order);
      for (var item in items) {
        await _db.into(_db.orderItems).insert(item.copyWith(orderId: Value(orderId)));
      }
      return orderId;
    });
  }

  // Payment Processing
  Future<void> processPayment(Payment payment) async {
    await _db.into(_db.payments).insert(payment);
    await _db.update(_db.orders)
      ..where((tbl) => tbl.id.equals(payment.orderId))
      ..write(const OrdersCompanion(status: Value('completed')));
  }

  // Inventory Update
  Future<void> updateStock(int productId, int quantity) async {
    await _db.update(_db.products)
      ..where((p) => p.id.equals(productId))
      ..write(ProductsCompanion.stock = 
          const Expression<int>(_db.products.stock - quantity));
  }
}
