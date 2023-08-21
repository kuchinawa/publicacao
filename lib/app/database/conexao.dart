/*
import 'package:path/path.dart';
import 'package:publicacao/app/database/script.dart';
import 'package:sqflite/sqflite.dart';

class Connection {
  static  Database? _db;

  static Future<Database?> get() async {
    if (_db == null) {
      var path = join(await getDatabasesPath(), 'banco_posts');
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, v) {
          db.execute(createTable);
          db.execute(insertPublicacao2);
        },
      );
    }
    return _db;
  }
}
*/