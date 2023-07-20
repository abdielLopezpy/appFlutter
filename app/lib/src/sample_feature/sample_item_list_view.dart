import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

const Color collection1Color = Color(0xFF8C1F28);
const Color collection2Color = Color(0xFF591C21);
const Color collection3Color = Color(0xFF044040);
const Color collection4Color = Color(0xFFD92525);
const Color collection5Color = Color(0xFFF2F2F2);

class ListBloc {
  final RealmResults<SampleItem> items;
  final Realm _realm;

  ListBloc(this.items) : _realm = items.realm;

  void addNewItem() {
    _realm.write(() =>
        _realm.add(SampleItem(ObjectId(), 1 + (items.lastOrNull?.no ?? 0))));
  }
}

class SampleItemListView extends StatelessWidget {
  const SampleItemListView({Key? key, required this.bloc}) : super(key: key);

  static const routeName = '/sampleItemListView';

  final ListBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sample Items',
          style: TextStyle(
            color: collection1Color,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
            color: collection1Color,
          ),
        ],
        backgroundColor: collection5Color,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: bloc.addNewItem,
        tooltip: 'Add new item',
        backgroundColor: collection1Color,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: bloc.items.changes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            restorationId: 'sampleItemListView',
            itemCount: bloc.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = bloc.items[index];
              return SampleItemTile(
                bloc: ItemBloc(item),
              );
            },
          );
        },
      ),
    );
  }
}

class ItemBloc {
  final SampleItem item;
  final Realm _realm;

  ItemBloc(this.item) : _realm = item.realm;

  void deleteItem() {
    _realm.write(() => _realm.delete(item));
  }
}

class SampleItemTile extends StatelessWidget {
  const SampleItemTile({
    super.key,
    required this.bloc,
  });

  final ItemBloc bloc;

  @override
  Widget build(BuildContext context) {
    final item = bloc.item;
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(color: collection4Color),
      onDismissed: (direction) => bloc.deleteItem(),
      child: ListTile(
        title: Text(
          'SampleItem ${item.no}',
          style: const TextStyle(
            color: collection1Color,
          ),
        ),
        leading: const CircleAvatar(
          foregroundImage: AssetImage('assets/images/flutter_logo.png'),
        ),
        onTap: () {
          Navigator.restorablePushNamed(
            context,
            SampleItemDetailsView.routeName,
          );
        },
      ),
    );
  }
}
