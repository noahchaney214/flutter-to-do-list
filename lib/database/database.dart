import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/*  database.dart 

    This is a database controller for SQLite. It contains a class for storing
    information in code called Item which stores the id, description, and checked boolean
    for each To Do Item. The DBController class consists of a constructor, update method, delete method,
    list method (named items()), and insert method. 

    Author: Noah Chaney
*/

DBController dbController = DBController();


class Item {
  final int? id;
  final String description;
  final bool checked;

  Item({
    this.id,
    required this.description,
    required this.checked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, // This field will auto-increment in the database
      'description': description,
      'checked': checked ? 1 : 0,
    };
  }
}


class DBController {
  late Future<Database> _database;

  DBController() {
    _database = _initializeDatabase();
  }

  Future<Database> _initializeDatabase() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
      join(await getDatabasesPath(), 'items.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, checked INTEGER)',
          //'DROP TABLE IF EXISTS items',
        );
      },
      version: 1,
    );
  }



  Future<void> updateItemDescription(String newDescription, bool checked, int id) async {
    // Get a reference to the database.
    final db = await _database;

    Item item = Item(id: id, description: newDescription, checked: checked);

   
    await db.update(
      'items',
      item.toMap(),

      where: 'id = ?',

      whereArgs: [id],
    );
  }

  Future<void> insertItem(Item item) async {
    final db = await _database;
    await db.insert(
      'items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the items from the database
  Future<List<Item>> items() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        description: maps[i]['description'],
        checked: maps[i]['checked'] == 1,
      );
    });
  }

  // Define a function that deletes an item from the database
  Future<void> deleteItem(int id) async {
    final db = await _database;
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


