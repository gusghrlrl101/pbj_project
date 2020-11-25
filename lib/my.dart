import 'package:sqflite/sqflite.dart';

class MyModel {
  Database db;

  MyModel() {
    () async {
      final databasesPath = await getDatabasesPath();
      final path = databasesPath + 'database.db';

      db = await openDatabase(
        path,
        version: 1,
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE class(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              professor TEXT,
              day INTEGER,
              startTime INTEGER,
              endTime INTEGER
            )''');
          await database.execute('''
            CREATE TABLE memo(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              content TEXT
            )''');
          await database.execute('''
            CREATE TABLE schedule(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT,
              date TEXT
            )''');
        },
      );
      print('mymodel: ${db?.isOpen}');
    }();
  }
}
