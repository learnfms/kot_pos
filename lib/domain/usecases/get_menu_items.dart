import 'package:dartz/dartz.dart';
import 'package:kot_pos/core/errors/failures.dart';
import 'package:kot_pos/domain/entities/menu_item.dart';
import 'package:kot_pos/domain/repositories/menu_repository.dart';

class GetMenuItems {
  final MenuRepository repository;

  GetMenuItems(this.repository);

  Future<Either<Failure, List<MenuItem>>> call() async {
    return await repository.getMenuItems();
  }
} 