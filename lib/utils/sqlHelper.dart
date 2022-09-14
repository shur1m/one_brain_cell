import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

class SqlHelper {
  static Future<Database> getDatabase(String dbName) async {
    String databasesPath = await getDatabasesPath();
    String path = Path.join(databasesPath, dbName);
    Database db = await openDatabase(path, version: 2);
    return db;
  }
}
