import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'pos_tables.dart';

part 'pos_database.g.dart';

@DriftDatabase(tables: [Products, Orders, OrderItems, Payments])
class POSDatabase extends _$POSDatabase {
  POSDatabase() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  // Create database instance
  static POSDatabase create() => POSDatabase();
}
