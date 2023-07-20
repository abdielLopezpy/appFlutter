import 'package:realm/realm.dart';

part 'sale.g.dart';

@RealmModel()
class _Sale {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  late double total;
  late DateTime date;
  late String customerId;
}
