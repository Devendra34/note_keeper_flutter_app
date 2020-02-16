import 'dart:io';
import 'package:note_keeper/constants/constants.dart';
import 'package:note_keeper/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  
  static const tableName = 'notes_table';
  static const colId = Constants.ID_KEY;
  static const colTitle = Constants.TITLE_KEY;
  static const colDescription = Constants.DESCRIPTION_KEY;
  static const colPriority = Constants.PRIORITY_KEY;
  static const colDate = Constants.DATE_KEY;
  static const colPassword = Constants.PASSWORD_KEY;

  DatabaseHelper._createInstance();
  
  factory DatabaseHelper(){
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }


  Future<Database> get database async {
    if (_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //get the directory for both android and ios
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    // open/create database at path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }
  
  void _createDb(Database db, int newVersion) async{
    
    await db.execute("CREATE TABLE $tableName "
        "( $colId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colTitle TEXT, $colDescription TEXT, "
        "$colPriority INTEGER, $colDate TEXT, "
        "$colPassword TEXT)");
  }
  
  // fetch all notes from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(tableName,orderBy: '$colPriority ASC');
    return result;
  }
  
  // insert note object in database
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(tableName, note.toMap());
    return result;
  }
  
  // delete note object from database
  Future<int> deleteNote(Note note) async{
    Database db = await this.database;
    var result = await db.delete(tableName,where: '$colId = ?',whereArgs: [note.id]);
    return result;
  }

  // update note object in database
  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    var result = await db.update(tableName, note.toMap(),where: '$colId = ?',whereArgs: [note.id]);
    return result;
  }
  //get no. of note object in database
  Future<int> getTotalNotes() async{
    List<Map<String, dynamic>> notes = await getNoteMapList();
    var result = Sqflite.firstIntValue(notes);
    return result;
  }

  Future<List<Note>> getNotesList() async {
    var noteMapList = await getNoteMapList();
    List<Note> notes = List<Note>();
    for (Map<String,dynamic> map in noteMapList) {
      notes.add(Note.fromMapObject(map));
    }
    return notes;
  }
}