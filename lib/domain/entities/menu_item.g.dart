// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MenuItemImpl _$$MenuItemImplFromJson(Map<String, dynamic> json) =>
    _$MenuItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      preparationTime: (json['preparationTime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MenuItemImplToJson(_$MenuItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'category': instance.category,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'tags': instance.tags,
      'preparationTime': instance.preparationTime,
    };
