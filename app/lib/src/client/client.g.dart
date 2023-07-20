// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Client extends _Client with RealmEntity, RealmObjectBase, RealmObject {
  Client(
    ObjectId id,
    String name,
    String emailAddress,
    String phoneNumber,
    String address,
    DateTime birthDate,
    String gender,
    String notes,
    DateTime registrationDate,
    DateTime lastContactDate,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', emailAddress);
    RealmObjectBase.set(this, 'phone', phoneNumber);
    RealmObjectBase.set(this, 'address', address);
    RealmObjectBase.set(this, 'birthdate', birthDate);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'notes', notes);
    RealmObjectBase.set(this, 'registrationDate', registrationDate);
    RealmObjectBase.set(this, 'lastContactDate', lastContactDate);
  }

  Client._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get emailAddress =>
      RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set emailAddress(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get phoneNumber =>
      RealmObjectBase.get<String>(this, 'phone') as String;
  @override
  set phoneNumber(String value) => RealmObjectBase.set(this, 'phone', value);

  @override
  String get address => RealmObjectBase.get<String>(this, 'address') as String;
  @override
  set address(String value) => RealmObjectBase.set(this, 'address', value);

  @override
  DateTime get birthDate =>
      RealmObjectBase.get<DateTime>(this, 'birthdate') as DateTime;
  @override
  set birthDate(DateTime value) =>
      RealmObjectBase.set(this, 'birthdate', value);

  @override
  String get gender => RealmObjectBase.get<String>(this, 'gender') as String;
  @override
  set gender(String value) => RealmObjectBase.set(this, 'gender', value);

  @override
  String get notes => RealmObjectBase.get<String>(this, 'notes') as String;
  @override
  set notes(String value) => RealmObjectBase.set(this, 'notes', value);

  @override
  DateTime get registrationDate =>
      RealmObjectBase.get<DateTime>(this, 'registrationDate') as DateTime;
  @override
  set registrationDate(DateTime value) =>
      RealmObjectBase.set(this, 'registrationDate', value);

  @override
  DateTime get lastContactDate =>
      RealmObjectBase.get<DateTime>(this, 'lastContactDate') as DateTime;
  @override
  set lastContactDate(DateTime value) =>
      RealmObjectBase.set(this, 'lastContactDate', value);

  @override
  Stream<RealmObjectChanges<Client>> get changes =>
      RealmObjectBase.getChanges<Client>(this);

  @override
  Client freeze() => RealmObjectBase.freezeObject<Client>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Client._);
    return const SchemaObject(ObjectType.realmObject, Client, 'Client', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('emailAddress', RealmPropertyType.string, mapTo: 'email'),
      SchemaProperty('phoneNumber', RealmPropertyType.string, mapTo: 'phone'),
      SchemaProperty('address', RealmPropertyType.string),
      SchemaProperty('birthDate', RealmPropertyType.timestamp,
          mapTo: 'birthdate'),
      SchemaProperty('gender', RealmPropertyType.string),
      SchemaProperty('notes', RealmPropertyType.string),
      SchemaProperty('registrationDate', RealmPropertyType.timestamp),
      SchemaProperty('lastContactDate', RealmPropertyType.timestamp),
    ]);
  }
}
