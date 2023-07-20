// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Category extends _Category
    with RealmEntity, RealmObjectBase, RealmObject {
  Category(
    ObjectId id,
    String name,
    String notes,
    DateTime registrationDate,
    DateTime lastContactDate,
    String creator,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'notes', notes);
    RealmObjectBase.set(this, 'registrationDate', registrationDate);
    RealmObjectBase.set(this, 'lastContactDate', lastContactDate);
    RealmObjectBase.set(this, 'creator', creator);
  }

  Category._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

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
  String get creator => RealmObjectBase.get<String>(this, 'creator') as String;
  @override
  set creator(String value) => RealmObjectBase.set(this, 'creator', value);

  @override
  Stream<RealmObjectChanges<Category>> get changes =>
      RealmObjectBase.getChanges<Category>(this);

  @override
  Category freeze() => RealmObjectBase.freezeObject<Category>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Category._);
    return const SchemaObject(ObjectType.realmObject, Category, 'Category', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('notes', RealmPropertyType.string),
      SchemaProperty('registrationDate', RealmPropertyType.timestamp),
      SchemaProperty('lastContactDate', RealmPropertyType.timestamp),
      SchemaProperty('creator', RealmPropertyType.string),
    ]);
  }
}
