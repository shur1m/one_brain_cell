import 'package:flutter/material.dart';
import 'package:one_brain_cell/MyApp.dart';
import 'package:one_brain_cell/utils/store/cardCollection.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'homePage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  //sqlite database initialization
  WidgetsFlutterBinding.ensureInitialized();
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'flashcards.db');

  Database database = await openDatabase(path, version: 2,
      onCreate: (Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE Flashcards (id INTEGER PRIMARY KEY, front TEXT, back TEXT, status INTEGER)');
  });

  //hive db initialization
  await Hive.initFlutter();
  Hive.registerAdapter(CardCollectionAdapter());

  await Hive.openBox('settings');
  await Hive.openBox('dir');
  await Hive.openBox('idlists');

  //resetting the storage for the app
  // await database.execute("delete from Flashcards");
  // await Hive.box('idlists').clear();

  runApp(MyApp());
}
