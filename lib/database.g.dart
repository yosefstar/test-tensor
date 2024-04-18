// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isFoodMeta = const VerificationMeta('isFood');
  @override
  late final GeneratedColumn<bool> isFood = GeneratedColumn<bool>(
      'is_food', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_food" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, path, date, isFood];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(Insertable<Photo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_food')) {
      context.handle(_isFoodMeta,
          isFood.isAcceptableOrUnknown(data['is_food']!, _isFoodMeta));
    } else if (isInserting) {
      context.missing(_isFoodMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      isFood: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_food'])!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  final int id;
  final String path;
  final DateTime date;
  final bool isFood;
  const Photo(
      {required this.id,
      required this.path,
      required this.date,
      required this.isFood});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['date'] = Variable<DateTime>(date);
    map['is_food'] = Variable<bool>(isFood);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      path: Value(path),
      date: Value(date),
      isFood: Value(isFood),
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      date: serializer.fromJson<DateTime>(json['date']),
      isFood: serializer.fromJson<bool>(json['isFood']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'date': serializer.toJson<DateTime>(date),
      'isFood': serializer.toJson<bool>(isFood),
    };
  }

  Photo copyWith({int? id, String? path, DateTime? date, bool? isFood}) =>
      Photo(
        id: id ?? this.id,
        path: path ?? this.path,
        date: date ?? this.date,
        isFood: isFood ?? this.isFood,
      );
  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('date: $date, ')
          ..write('isFood: $isFood')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, date, isFood);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.path == this.path &&
          other.date == this.date &&
          other.isFood == this.isFood);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<int> id;
  final Value<String> path;
  final Value<DateTime> date;
  final Value<bool> isFood;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.date = const Value.absent(),
    this.isFood = const Value.absent(),
  });
  PhotosCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    required DateTime date,
    required bool isFood,
  })  : path = Value(path),
        date = Value(date),
        isFood = Value(isFood);
  static Insertable<Photo> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<DateTime>? date,
    Expression<bool>? isFood,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (date != null) 'date': date,
      if (isFood != null) 'is_food': isFood,
    });
  }

  PhotosCompanion copyWith(
      {Value<int>? id,
      Value<String>? path,
      Value<DateTime>? date,
      Value<bool>? isFood}) {
    return PhotosCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      date: date ?? this.date,
      isFood: isFood ?? this.isFood,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isFood.present) {
      map['is_food'] = Variable<bool>(isFood.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('date: $date, ')
          ..write('isFood: $isFood')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $PhotosTable photos = $PhotosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [photos];
}
