import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../settings/settings_view.dart';
import 'inventory_item.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class InventoryListBloc {
  final RealmResults<InventoryItem> inventoryItems;
  final Realm _realm;

  InventoryListBloc(this.inventoryItems) : _realm = inventoryItems.realm;

  void addNewItem(
    String name,
    String description,
    String category,
    int quantity,
    double price,
  ) {
    _realm.write(() {
      _realm.add(InventoryItem(
        ObjectId(),
        name,
        description,
        category,
        quantity,
        price,
        DateTime.now(),
        DateTime.now(),
      ));
    });
  }

  void updateItem(InventoryItem item) {
    _realm.write(() {
      final updatedItem = _realm.find<InventoryItem>(item.id);
      if (updatedItem != null) {
        updatedItem.name = item.name;
        updatedItem.description = item.description;
        updatedItem.category = item.category;
        updatedItem.quantity = item.quantity;
        updatedItem.price = item.price;
      }
    });
  }

  void deleteItem(InventoryItem item) {
    _realm.write(() {
      _realm.delete(item);
    });
  }
}

class InventoryListView extends StatefulWidget {
  const InventoryListView({Key? key, required this.bloc}) : super(key: key);

  static const routeName = '/inventoryListView';

  final InventoryListBloc bloc;

  @override
  _InventoryListViewState createState() => _InventoryListViewState();
}

class _InventoryListViewState extends State<InventoryListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: collection1Color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsView.routeName);
            },
            color: collection1Color,
          ),
        ],
        backgroundColor: collection5Color,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddItemDialog(context);
        },
        tooltip: 'Add new item',
        backgroundColor: collection1Color,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<RealmResults<InventoryItem>>(
        stream: widget.bloc.inventoryItems.changes
            .map((changes) => changes.results)
            .asBroadcastStream(),
        initialData: widget.bloc.inventoryItems,
        builder: (context, snapshot) {
          final items = snapshot.data;
          if (!snapshot.hasData || items == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            restorationId: 'inventoryListView',
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              return InventoryItemTile(item: item, bloc: widget.bloc);
            },
          );
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String description = '';
        String category = '';
        int quantity = 0;
        double price = 0;

        return AlertDialog(
          title: const Text('Add New Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    description = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    category = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  onChanged: (value) {
                    quantity = int.tryParse(value) ?? 0;
                  },
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.bloc.addNewItem(
                  name,
                  description,
                  category,
                  quantity,
                  price,
                );

                Navigator.of(context).pop();

                // Display a notification
                const snackBar =
                    SnackBar(content: Text('Item added successfully.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // Navigate to the screen that shows all items and replace the current screen
                Navigator.pushReplacementNamed(
                    context, InventoryListView.routeName);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class InventoryItemTile extends StatelessWidget {
  const InventoryItemTile({
    Key? key,
    required this.item,
    required this.bloc,
  }) : super(key: key);

  final InventoryItem item;
  final InventoryListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(color: collection4Color),
      onDismissed: (direction) => bloc.deleteItem(item),
      child: ListTile(
        title: Text(
          item.name,
          style: const TextStyle(
            color: collection1Color,
            fontSize: 18,
          ),
        ),
        leading: const CircleAvatar(
          foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InventoryItemDetailsView(item: item, bloc: bloc),
            ),
          );
        },
      ),
    );
  }
}

class InventoryItemDetailsView extends StatelessWidget {
  static const routeName = '/inventoryItem';

  final InventoryItem item;
  final InventoryListBloc bloc;

  const InventoryItemDetailsView({
    Key? key,
    required this.item,
    required this.bloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Item Details',
          style: TextStyle(
            color: collection1Color,
          ),
        ),
        backgroundColor: collection5Color,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${item.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${item.description}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${item.category}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: ${item.quantity}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showUpdateItemDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: collection1Color,
              ),
              child: const Text(
                'Update Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = item.name;
        String description = item.description;
        String category = item.category;
        int quantity = item.quantity;
        double price = item.price;

        return AlertDialog(
          title: const Text('Update Item'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    name = value;
                  },
                  controller: TextEditingController(text: name),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    description = value;
                  },
                  controller: TextEditingController(text: description),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    category = value;
                  },
                  controller: TextEditingController(text: category),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  onChanged: (value) {
                    quantity = int.tryParse(value) ?? 0;
                  },
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: quantity.toString()),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0;
                  },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: TextEditingController(text: price.toString()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedItem = InventoryItem(
                  item.id,
                  name,
                  description,
                  category,
                  quantity,
                  price,
                  item.createdAt,
                  DateTime.now(),
                );
                bloc.updateItem(updatedItem);
                Navigator.of(context).pop(updatedItem);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    ).then((updatedItem) {
      if (updatedItem != null) {
        // Display a notification
        const snackBar = SnackBar(content: Text('Item updated successfully.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigate to the screen that shows all items
        Navigator.pushNamed(context, InventoryListView.routeName);

        // Handle updated item
        print('Updated item: $updatedItem');
      }
    });
  }
}
