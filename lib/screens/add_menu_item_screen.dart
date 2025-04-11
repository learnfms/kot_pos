import 'package:flutter/material.dart';
import '../resp/menu_repository.dart';
import '../model/menu_item.dart';

class AddMenuItemScreen extends StatefulWidget {
  const AddMenuItemScreen({super.key});

  @override
  _AddMenuItemScreenState createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final MenuRepository repository = MenuRepository();

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Menu Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter item name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Price must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Enter item category',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                  hintText: 'Enter image URL',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final urlPattern = RegExp(
                      r'^https?:\/\/([\w-]+\.)+[\w-]+(\/[\w- .\/?%&=]*)?$',
                    );
                    if (!urlPattern.hasMatch(value)) {
                      return 'Please enter a valid URL';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Create a MenuItem object
                      final menuItem = MenuItem(
                        id: 0, // The backend will assign the actual ID
                        name: nameController.text.trim(),
                        price: double.parse(priceController.text),
                        category: categoryController.text.trim(),
                        imageUrl: imageUrlController.text.trim().isNotEmpty 
                            ? imageUrlController.text.trim() 
                            : null,
                      );

                      await repository.addMenuItem(menuItem);
                      
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Menu item added successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context, true); // Pass true to indicate success
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add menu item: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
