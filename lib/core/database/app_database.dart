import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:injectable/injectable.dart';

part 'app_database.g.dart';

/// Users table for local caching of authenticated user data.
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get name => text()();
  TextColumn get role => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// SyncQueue table to hold offline mutations that will be retried when the network is online.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get endpoint => text()();
  TextColumn get method => text().withLength(min: 3, max: 10)();
  TextColumn get payload => text()(); // JSON-encoded string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

/// Main application database utilizing Drift.
@DriftDatabase(tables: [Users, SyncQueue])
@lazySingleton
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbDir.path, 'app_cache.db'));
    return NativeDatabase.createInBackground(file);
  });
}
