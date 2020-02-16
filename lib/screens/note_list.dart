import 'package:flutter/material.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/screens/note-details.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> notes;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var count = 0;

  @override
  void initState() {
    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('Notes'),),
      body: getNotesListView(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Note',
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: (){
          debugPrint('Floating Button pressed');
          _navigateToDetail(Note('','',2,'',),'Add Note');
        },
      ),
    );
  }
  ListView getNotesListView(){
    TextStyle textStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context,int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(notes[position].priority),
              child: getPriorityIcons(notes[position].priority),
            ),
            title: Text(notes[position].title,style: textStyle,),
            subtitle: Text(notes[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete,color: Colors.red),
              onTap: () => _delete(context,notes[position]),
            ),
            onTap: (){
              debugPrint('List Card on tab');
              _navigateToDetail(notes[position],'Edit Note');
            },
          ),
        );
      },
    );
  }

  // return priority color
  Color getPriorityColor(int priority) {
    switch (priority){
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // return priority color
  Icon getPriorityIcons(int priority){
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
      case 2:
        return Icon(Icons.keyboard_arrow_right);
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note);
    if(result != 0){
      _showSnackBar('Note Deleted Successfully');
      updateListView();
    } else {
      _showSnackBar('Note not Deleted');
    }
  }

  void _showSnackBar(String message) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(message))
    );
  }

  void _navigateToDetail(Note note, String title) async {
    String action = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetails(note, title);
    }));
    if (action != null){
      _showSnackBar(action);
      if (action != 'no_action'){
        updateListView();
      }
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Note>> noteListFuture = databaseHelper.getNotesList();
      noteListFuture.then((notes){
        setState(() {
          this.notes = notes;
          this.count = notes.length;
        });
      });
    });
  }
}