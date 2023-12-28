import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initialize();
    return _database!;
  }

  Future<void> copyDatabase(String dbName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);

    // Check if the database file already exists
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // If the database doesn't exist, copy it from assets
      ByteData data = await rootBundle.load(join("assets", "database", "$dbName"));
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes, flush: true);
    }
  }

  Future<Database> _initialize() async {
    String dbName = 'topic.db';
    // Initialize databaseFactory for PC when using sqflite_common_ffi
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    // Construct a file path to copy database to
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    // Check if the database file exists in the app's local storage
    // and copy it if it does not
    await copyDatabase(dbName);
    var database = await openDatabase(
      path,
      version: 1,
      singleInstance: true,
    );
    return database;
  }
}