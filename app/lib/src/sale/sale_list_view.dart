import 'package:flutter/material.dart';
import '../sale/sale.dart';
import 'package:realm/realm.dart';

import '../settings/settings_view.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class SaleListBloc {
  final RealmResults<Sale> sales;
  final Realm _realm;

  SaleListBloc(this.sales) : _realm = sales.realm;

  void addNewSale(
      double total, DateTime date, String customerId, String products) {
    _realm.write(() {
      _realm.add(Sale(
        ObjectId(),
        total,
        date,
        customerId,
      ));
    });
  }

  void updateSale(Sale sale) {
    _realm.write(() {
      final updatedSale = _realm.find<Sale>(sale.id);
      if (updatedSale != null) {
        updatedSale.total = sale.total;
        updatedSale.date = sale.date;
        updatedSale.customerId = sale.customerId;
      }
    });
  }

  void deleteSale(Sale sale) {
    _realm.write(() {
      _realm.delete(sale);
    });
  }
}

class SaleListView extends StatefulWidget {
  const SaleListView({Key? key, required this.bloc}) : super(key: key);

  static const routeName = '/saleListView';

  final SaleListBloc bloc;

  @override
  _SaleListViewState createState() => _SaleListViewState();
}

class _SaleListViewState extends State<SaleListView> {
  void _showAddSaleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double total = 0;
        DateTime date = DateTime.now();
        String customerId = '';
        List<String> products = [];

        return AlertDialog(
          title: const Text('Add New Sale'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Total'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    total = double.tryParse(value) ?? 0;
                  },
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context, (selectedDate) {
                      date = selectedDate ?? DateTime.now();
                    });
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Date'),
                    child: Text(date.toString()),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Customer ID'),
                  onChanged: (value) {
                    customerId = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Products'),
                  onChanged: (value) {
                    products = value.split(',').map((e) => e.trim()).toList();
                  },
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
                widget.bloc.addNewSale(
                  total,
                  date,
                  customerId,
                  products.join(','),
                );

                Navigator.of(context).pop();

                // Display a notification
                const snackBar =
                    SnackBar(content: Text('Sale added successfully.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                // Navigate to the screen that shows all sales and replace the current screen
                Navigator.pushReplacementNamed(context, SaleListView.routeName);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _selectDate(
      BuildContext context, void Function(DateTime?) onDateSelected) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    onDateSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales',
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
          _showAddSaleDialog(context);
        },
        tooltip: 'Add new sale',
        backgroundColor: collection1Color,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<RealmResults<Sale>>(
        stream: widget.bloc.sales.changes
            .map((changes) => changes.results)
            .asBroadcastStream(),
        initialData: widget.bloc.sales,
        builder: (context, snapshot) {
          final sales = snapshot.data;
          if (!snapshot.hasData || sales == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: sales.length,
            itemBuilder: (BuildContext context, int index) {
              final sale = sales[index];
              return SaleTile(sale: sale, bloc: widget.bloc);
            },
          );
        },
      ),
    );
  }
}

class SaleTile extends StatelessWidget {
  const SaleTile({
    Key? key,
    required this.sale,
    required this.bloc,
  }) : super(key: key);

  final Sale sale;
  final SaleListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(sale.id),
      background: Container(color: collection4Color),
      onDismissed: (direction) => bloc.deleteSale(sale),
      child: ListTile(
        title: Text(
          'Total: ${sale.total.toStringAsFixed(2)}',
          style: const TextStyle(
            color: collection1Color,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Date: ${sale.date.toString()}',
          style: const TextStyle(
            color: collection1Color,
            fontSize: 16,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaleDetailsView(sale: sale, bloc: bloc),
            ),
          );
        },
      ),
    );
  }
}

class SaleDetailsView extends StatelessWidget {
  static const routeName = '/sale';

  final Sale sale;
  final SaleListBloc bloc;

  const SaleDetailsView({
    Key? key,
    required this.sale,
    required this.bloc,
  }) : super(key: key);

  void _showUpdateSaleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double total = sale.total;
        DateTime date = sale.date;
        String customerId = sale.customerId;

        return AlertDialog(
          title: const Text('Update Sale'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Total'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    total = double.tryParse(value) ?? 0;
                  },
                  controller: TextEditingController(text: total.toString()),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context, (selectedDate) {
                      date = selectedDate ?? DateTime.now();
                    });
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Date'),
                    child: Text(date.toString()),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Customer ID'),
                  onChanged: (value) {
                    customerId = value;
                  },
                  controller: TextEditingController(text: customerId),
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
                final updatedSale = Sale(
                  sale.id,
                  total,
                  date,
                  customerId,
                );
                bloc.updateSale(updatedSale);
                Navigator.of(context).pop(updatedSale);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    ).then((updatedSale) {
      if (updatedSale != null) {
        // Display a notification
        const snackBar = SnackBar(content: Text('Sale updated successfully.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigate to the screen that shows all sales
        Navigator.pushNamed(context, SaleListView.routeName);

        // Handle updated sale
        print('Updated sale: $updatedSale');
      }
    });
  }

  void _selectDate(
      BuildContext context, void Function(DateTime?) onDateSelected) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: sale.date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    onDateSelected(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sale Details',
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
              'Total: ${sale.total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${sale.date.toString()}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Customer ID: ${sale.customerId}',
              style: const TextStyle(
                fontSize: 18,
                color: collection1Color,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showUpdateSaleDialog(context);
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
}
