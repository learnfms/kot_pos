import 'package:flutter/material.dart';
import 'package:kot_pos/domain/entities/menu_item.dart';

class MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback? onTap;

  const MenuItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              if (item.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.description!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: Text(item.category),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  if (!item.isAvailable)
                    const Chip(
                      label: Text('Unavailable'),
                      backgroundColor: Colors.red,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 