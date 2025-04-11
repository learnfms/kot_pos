import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String name,
    required double price,
    required String category,
    String? description,
    String? imageUrl,
    required bool isAvailable,
    @Default([]) List<String> tags,
    @Default(0) int preparationTime,
  }) = _MenuItem;

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
} 