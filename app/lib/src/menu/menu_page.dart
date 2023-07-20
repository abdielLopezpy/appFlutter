import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar el paquete intl para formatear fechas
import 'package:listy/src/sample_feature/sample_item_list_view.dart';
import 'package:listy/src/authentication/login_page.dart';

import '../category/category_list_view.dart';
import '../client/client_list_view.dart';
import '../employee/employee_list_view.dart';
import '../inventory/inventory_item_list_view.dart';
import '../sale/sale_list_view.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class MenuPage extends StatefulWidget {
  static const String routeName = '/menu';

  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Stream<DateTime> _dateTimeStream;

  @override
  void initState() {
    super.initState();
    // Inicializar el Stream para obtener la fecha y hora actual cada segundo
    _dateTimeStream = Stream<DateTime>.periodic(
        const Duration(seconds: 1), (_) => DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Menu',
            style: TextStyle(
              color: collection1Color,
            ),
          ),
          actions: [
            StreamBuilder<DateTime>(
              stream: _dateTimeStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                // Formatear la fecha y hora actual con el formato deseado (días en letras en inglés y hora con minutos y segundos)
                final formattedDate = DateFormat('EEEE, MMMM d, y - HH:mm:ss')
                    .format(snapshot.data!);

                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      color: collection1Color,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              color: collection1Color,
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ],
          backgroundColor: collection5Color,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildMenuItem(
              icon: Icons.view_list,
              label: 'View Sample Items',
              color: collection2Color,
              onPressed: () {
                Navigator.pushNamed(context, SampleItemListView.routeName);
              },
            ),
            _buildMenuItem(
              icon: Icons.inventory,
              label: 'Manage Inventory',
              color: collection3Color,
              onPressed: () {
                // Handle inventory management
                Navigator.pushNamed(context, InventoryListView.routeName);
              },
            ),
            _buildMenuItem(
              icon: Icons.person,
              label: 'Manage Clients',
              color: collection4Color,
              onPressed: () {
                // Handle customer management
                Navigator.pushNamed(context, ClientListView.routeName);
              },
            ),
            _buildMenuItem(
              icon: Icons.shopping_cart,
              label: 'Make a Sale',
              color: collection1Color,
              onPressed: () {
                // Handle sales
                Navigator.pushNamed(context, SaleListView.routeName);
              },
            ),
            _buildMenuItem(
              icon: Icons.people,
              label: 'Manage Employees',
              color: collection2Color,
              onPressed: () {
                // Handle employee management
                Navigator.pushNamed(context, EmployeeListView.routeName);
              },
            ),
            _buildMenuItem(
              icon: Icons.manage_search,
              label: 'Manage Category',
              color: collection3Color,
              onPressed: () {
                // Llevar al usuario a la vista de gestión de categorías
                Navigator.pushNamed(context, CategoryListView.routeName);
              },
            ),
            _buildMenuItem(
              icon: Icons.logout,
              label: 'Log Out',
              color: collection1Color,
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        primary: color,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
