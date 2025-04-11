import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final int id;
  final String name;
  final double price;
  final String category;
  final String? imageUrl;

  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, price, category, imageUrl];

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  // Create MenuItem from Map
  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
      category: map['category'] as String,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  // Create a copy of MenuItem with some fields changed
  MenuItem copyWith({
    int? id,
    String? name,
    double? price,
    String? category,
    String? imageUrl,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
} 