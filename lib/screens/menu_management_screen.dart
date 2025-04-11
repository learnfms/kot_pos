import 'package:flutter/material.dart';
import '../model/menu_item.dart';
import '../resp/menu_repository.dart';
import 'add_menu_item_screen.dart';

class MenuManagementScreen extends StatefulWidget {
  @override
  _MenuManagementScreenState createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final MenuRepository repository = MenuRepository();
  late Future<List<MenuItem>> futureMenuItems;

  @override
  void initState() {
    super.initState();
    futureMenuItems = repository.fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Menu Items'),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: futureMenuItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching menu items'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No menu items available'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: item.imageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            item.imageUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 56,
                                height: 56,
                                color: Colors.grey[200],
                                child: Icon(Icons.fastfood, color: Colors.grey),
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[200],
                          child: Icon(Icons.fastfood, color: Colors.grey),
                        ),
                  title: Text(
                    '${item.name} - \$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item.category,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      // Show confirmation dialog
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Item'),
                          content: Text('Are you sure you want to delete this item?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true) {
                        await repository.deleteMenuItem(item.id);
                        setState(() {
                          futureMenuItems = repository.fetchMenuItems();
                        });
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add menu item screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMenuItemScreen(),
            ),
          );
          
          if (result == true) {
            setState(() {
              futureMenuItems = repository.fetchMenuItems();
            });
          }
        },
        backgroundColor: Colors.deepOrange,
        child: Icon(Icons.add),
        tooltip: 'Add Menu Item',
      ),
    );
  }
}
