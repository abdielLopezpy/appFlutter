// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Sale extends _Sale with RealmEntity, RealmObjectBase, RealmObject {
  Sale(
    ObjectId id,
    double total,
    DateTime date,
    String customerId,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'total', total);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'customerId', customerId);
  }

  Sale._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  double get total => RealmObjectBase.get<double>(this, 'total') as double;
  @override
  set total(double value) => RealmObjectBase.set(this, 'total', value);

  @override
  DateTime get date => RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set date(DateTime value) => RealmObjectBase.set(this, 'date', value);

  @override
  String get customerId =>
      RealmObjectBase.get<String>(this, 'customerId') as String;
  @override
  set customerId(String value) =>
      RealmObjectBase.set(this, 'customerId', value);

  @override
  Stream<RealmObjectChanges<Sale>> get changes =>
      RealmObjectBase.getChanges<Sale>(this);

  @override
  Sale freeze() => RealmObjectBase.freezeObject<Sale>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Sale._);
    return const SchemaObject(ObjectType.realmObject, Sale, 'Sale', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('total', RealmPropertyType.double),
      SchemaProperty('date', RealmPropertyType.timestamp),
      SchemaProperty('customerId', RealmPropertyType.string),
    ]);
  }
}
