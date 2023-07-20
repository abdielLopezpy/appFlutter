import 'package:realm/realm.dart';

part 'category.g.dart';

@RealmModel()
class _Category {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  @MapTo('name')
  late String name;

  @MapTo('notes')
  late String notes;

  @MapTo('registrationDate')
  late DateTime registrationDate;

  @MapTo('lastContactDate')
  late DateTime lastContactDate;

  @MapTo('creator')
  late String creator;
}
