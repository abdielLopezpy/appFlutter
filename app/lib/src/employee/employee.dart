import 'package:realm/realm.dart';

part 'employee.g.dart';

@RealmModel()
class _Employee {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;

  @MapTo('name')
  late String name;

  @MapTo('email')
  late String emailAddress;

  @MapTo('phone')
  late String phoneNumber;

  @MapTo('address')
  late String address;

  @MapTo('birthdate')
  late DateTime birthDate;

  @MapTo('gender')
  late String gender;

  @MapTo('position')
  late String position;

  @MapTo('registrationDate')
  late DateTime registrationDate;

  @MapTo('lastContactDate')
  late DateTime lastContactDate;
}
