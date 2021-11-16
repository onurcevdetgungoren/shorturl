import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shorturl/model/urlHistory.dart';
import 'package:shorturl/utils/dbHelper_base.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper implements DbHeplerBase {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "history.db");

// Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "history.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
// open the database
    return await openDatabase(path, readOnly: false);
  }

  @override
  Future<int> addHistory(UrlHistoryModel urlHistoryModel) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("urlhistory", urlHistoryModel.toMap());
    return sonuc;
  }

  @override
  Future<List<Map<String, dynamic>>> getHistory() async {
    var db = await _getDatabase();
    var sonuc = await db.query("urlhistory");
    print(sonuc.toString());
    return sonuc;
  }

  @override
  Future<int> deleteHistory(int urlID) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete("urlhistory", where: 'urlID = ?', whereArgs: [urlID]);
    return sonuc;
  }
}
