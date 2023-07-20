import 'package:realm/realm.dart';

part 'inventory_item.g.dart';

@RealmModel()
class _InventoryItem {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  @MapTo('name')
  late String name;

  @MapTo('description')
  late String description;

  @MapTo('category')
  late String category;

  @MapTo('quantity')
  late int quantity;

  @MapTo('price')
  late double price;

  @MapTo('createdAt')
  late DateTime createdAt;

  @MapTo('updatedAt')
  late DateTime updatedAt;
}
