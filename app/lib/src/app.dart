import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:realm/realm.dart';

import 'authentication/login_page.dart';
import 'authentication/register_page.dart';
import 'category/category.dart';
import 'category/category_list_view.dart';
import 'employee/employee_list_view.dart';
import 'menu/menu_page.dart';
import 'sample_feature/sample_item_details_view.dart';
import 'settings/settings_controller.dart';
import 'sample_feature/sample_item.dart';
import 'client/client.dart';
import 'client/client_list_view.dart';
import 'settings/settings_view.dart';
import 'sample_feature/sample_item_list_view.dart';
import 'employee/employee.dart';
import 'inventory/inventory_item.dart';
import 'inventory/inventory_item_list_view.dart';
import 'sale/sale_list_view.dart';
import 'sale/sale.dart';

class MyApp extends StatelessWidget {
  final App app;
  final SettingsController settingsController;
  final RealmResults<SampleItem> items;
  final RealmResults<Client> clients;
  final RealmResults<Employee> employees;
  final RealmResults<InventoryItem> inventoryItems;
  final RealmResults<Category> categories;
  final RealmResults<Sale> sales;

  const MyApp({
    Key? key,
    required this.app,
    required this.settingsController,
    required this.items,
    required this.clients,
    required this.employees,
    required this.inventoryItems,
    required this.categories,
    required this.sales,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          initialRoute: LoginPage.routeName,
          routes: {
            LoginPage.routeName: (context) => LoginPage(
                  app: app,
                  onLogin: () {
                    Navigator.pushNamed(context, MenuPage.routeName);
                  },
                ),
            RegisterPage.routeName: (context) => RegisterPage(
                  app: app,
                  onRegister: () {
                    // Handle successful registration if needed
                  },
                ),
            MenuPage.routeName: (context) => const MenuPage(),
            SampleItemListView.routeName: (context) => SampleItemListView(
                  bloc: ListBloc(items),
                ),
            SampleItemDetailsView.routeName: (context) =>
                const SampleItemDetailsView(),
            SettingsView.routeName: (context) =>
                SettingsView(controller: settingsController),
            ClientListView.routeName: (context) => ClientListView(
                  bloc: ClientListBloc(clients),
                ),
            EmployeeListView.routeName: (context) => EmployeeListView(
                  bloc: EmployeeListBloc(employees),
                ),
            InventoryListView.routeName: (context) => InventoryListView(
                  bloc: InventoryListBloc(inventoryItems),
                ),
            CategoryListView.routeName: (context) => CategoryListView(
                  bloc: CategoryListBloc(categories),
                ),
            SaleListView.routeName: (context) => SaleListView(
                  bloc: SaleListBloc(sales),
                ),
          },
        );
      },
    );
  }
}
