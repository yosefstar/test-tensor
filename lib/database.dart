import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';

part 'database.g.dart';

@DataClassName('Photo')
class Photos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get isFood => boolean()();
}

@DriftDatabase(tables: [Photos])
class AppDatabase extends _$AppDatabase {
  Future<List<Photo>> getAllPhotos() async {
    return await select(photos).get();
  }

  // 引数なしのコンストラクタで_openConnectionを直接使用
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

// シングルトンインスタンスの提供
final AppDatabase appDatabase = AppDatabase();

// シングルトンインスタンスにアクセスするための関数
AppDatabase getAppDatabaseInstance() {
  return appDatabase;
}
