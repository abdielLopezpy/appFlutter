import 'package:flutter/material.dart';
import 'package:listy/src/category/category.dart';
import 'package:listy/src/inventory/inventory_item.dart';
import 'package:listy/src/settings/settings_service.dart';
import 'package:realm/realm.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/sample_feature/sample_item.dart';
import 'src/client/client.dart';
import 'src/employee/employee.dart';
import 'src/sale/sale.dart';

void main() async {
  final app = App(AppConfiguration('devicesync-bbkmd'));
  final user = await logInOrRegisterUser(app);

  final realm = Realm(Configuration.flexibleSync(user, [
    SampleItem.schema,
    Client.schema,
    Employee.schema,
    InventoryItem.schema,
    Category.schema,
    Sale.schema,
  ]));
  realm.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.add(realm.all<SampleItem>());
    mutableSubscriptions.add(realm.all<Client>());
    mutableSubscriptions.add(realm.all<Employee>());
    mutableSubscriptions.add(realm.all<InventoryItem>());
    mutableSubscriptions.add(realm.all<Category>());
    mutableSubscriptions.add(realm.all<Sale>());
  });
  final allItems = realm.all<SampleItem>();
  final allClients = realm.all<Client>();
  final allEmployees = realm.all<Employee>();
  final allInventoryItems = realm.all<InventoryItem>();
  final allCategories = realm.all<Category>();
  final allSales = realm.all<Sale>();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  runApp(
    MyApp(
      app: app,
      settingsController: settingsController,
      items: allItems,
      clients: allClients,
      employees: allEmployees,
      inventoryItems: allInventoryItems,
      categories: allCategories,
      sales: allSales,
    ),
  );
}

Future<User> logInOrRegisterUser(App app) async {
  final user = app.currentUser;

  if (user == null) {
    final credentials = Credentials.anonymous();
    return await app.logIn(credentials);
  }

  return user;
}
