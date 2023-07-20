import 'package:realm/realm.dart';

part 'sample_item.g.dart';

@RealmModel()
class _SampleItem {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late int no;
}
