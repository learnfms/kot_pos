class KOTRepository {
  final POSDatabase _db;

  KOTRepository(this._db);

  Stream<List<Order>> watchActiveKOTs() {
    return _db.select(_db.orders)
      ..where((o) => o.status.equals('pending'))
      ..watch();
  }

  Future<void> updateKOTStatus(int orderId, String status) {
    return _db.update(_db.orders)
      ..where((o) => o.id.equals(orderId))
      ..write(OrdersCompanion(status: Value(status)));
  }
}
