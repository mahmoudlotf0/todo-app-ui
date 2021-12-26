import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/task.dart';

class DBHelper {
  static Database? _database;
  static final int _version = 1;
  static final _tableName = 'tasks';
  static Future<void> initDatabase() async {
    print('-------------- Database is ready --------------');
    if (_database != null) {
      print('Database not null');
      return;
    } else {
      try {
        String path = await getDatabasesPath() + 'task.db';
        print('in database path');
        _database = await openDatabase(
          path,
          version: _version,
          onCreate: (Database database, int version) async {
            await database.execute(
                'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER)');
            print('Create a new database ');
          },
        );
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('Insert function called');
    // values must be Json (Key , Value)
    try {
      return await _database!.insert(_tableName, task!.toJson());
    } catch (e) {
      print('We are here');
      return 90000;
    }
  }

  static Future<int> delete(Task? task) async {
    print('delete function called');
    return await _database!
        .delete(_tableName, where: 'id = ?', whereArgs: [task!.id]);
  }

  static Future<int> deleteAll() async {
    print('deleteAll function called');
    return await _database!.delete(_tableName);
  }

  static Future<int> update(int id) async {
    print('Update function called');
    return await _database!.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ? 
      ''', [1, id]);
  }

// qurey : btst3lm 3n query m3en
  static Future<List<Map<String, dynamic>>> query() async {
    print('Query function called');
    return await _database!.query(_tableName);
  }
}
