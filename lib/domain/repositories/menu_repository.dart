import 'package:dartz/dartz.dart';
import 'package:kot_pos/core/errors/failures.dart';
import 'package:kot_pos/domain/entities/menu_item.dart';

abstract class MenuRepository {
  Future<Either<Failure, List<MenuItem>>> getMenuItems();
  Future<Either<Failure, MenuItem>> getMenuItem(String id);
  Future<Either<Failure, MenuItem>> addMenuItem(MenuItem item);
  Future<Either<Failure, MenuItem>> updateMenuItem(MenuItem item);
  Future<Either<Failure, void>> deleteMenuItem(String id);
  Future<Either<Failure, List<MenuItem>>> getMenuItemsByCategory(String category);
} 