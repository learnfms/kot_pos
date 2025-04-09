import 'package:drift/drift.dart';

@DataClassName('Product')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  IntColumn get stock => integer()();
  TextColumn get category => text()();
}

@DataClassName('Order')
class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tableNumber => integer()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  RealColumn get total => real()();
}

@DataClassName('OrderItem')
class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  TextColumn get modifiers => text().nullable()();
}

@DataClassName('Payment')
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  RealColumn get amount => real()();
  TextColumn get method => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}
