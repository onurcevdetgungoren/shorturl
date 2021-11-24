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
    //Singleton
    //const ta db oluşup oluşmadığının kontrolünü sağladık
    //return olduğu için factory olarak kullandık
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper;
    } else {
      return _databaseHelper;
    }
  }

  //isimlendirilmiş const, bu sayede dbHelper null ise oluşturulmasını sağladık.
  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    //Burada db var mı kontrolü yapılıyor, yoksa aşağıdaki initializedb fonksiyonu çağırılıp oluşturuluyor.
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      //db oluşturulmuş ise mevcut olanı return ediyor.
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
  Future<List<UrlHistoryModel>> getHistory() async {
    List<UrlHistoryModel> _urlHistoryList = List<UrlHistoryModel>();
    List<Map<String, dynamic>> _mapList;
    var db = await _getDatabase();
    var sonuc = await db.query("urlhistory");
    _mapList = sonuc;
    print(_mapList.toString());
    for (Map<String, dynamic> a in _mapList) {
      _urlHistoryList.add(UrlHistoryModel.fromMap(a));
      print(_urlHistoryList[0].longUrl);
    }
    return _urlHistoryList;
  }

  @override
  Future<int> deleteHistory(int urlID) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete("urlhistory", where: 'urlID = ?', whereArgs: [urlID]);
    return sonuc;
  }

  @override
  Future<bool> isInHistory(String url) async {
    var db = await _getDatabase();
    var sonuc =
        await db.query("urlhistory", where: 'longUrl = ?', whereArgs: [url]);
    return sonuc.isNotEmpty;
  }
}
