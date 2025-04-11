import 'package:get/get.dart';
import 'package:kot_pos/core/errors/failures.dart';
import 'package:kot_pos/domain/entities/menu_item.dart';
import 'package:kot_pos/domain/usecases/get_menu_items.dart';

class MenuController extends GetxController {
  final GetMenuItems getMenuItems;
  
  final RxList<MenuItem> menuItems = <MenuItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  MenuController({required this.getMenuItems});

  Future<void> loadMenuItems() async {
    isLoading.value = true;
    error.value = '';
    
    final result = await getMenuItems();
    
    result.fold(
      (failure) {
        error.value = _mapFailureToMessage(failure);
        menuItems.clear();
      },
      (items) {
        menuItems.assignAll(items);
      },
    );
    
    isLoading.value = false;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
} 