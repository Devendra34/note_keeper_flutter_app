import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/note.dart';
import 'package:note_keeper/utils/database_helper.dart';

class NoteDetails extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetails(this.note, this.appBarTitle);

  @override
  _NoteDetailsState createState() =>
      _NoteDetailsState(this.note, this.appBarTitle);
}

class _NoteDetailsState extends State<NoteDetails> {
  final _priorities = ['High', 'Low'];

  String appBarTitle;
  Note note;
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool _obscureText = true;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final focus = FocusNode();
  bool verified = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _NoteDetailsState(this.note, this.appBarTitle);

  @override
  void initState() {
    _titleController.text = note.title;
    _descriptionController.text = note.description;
    _passwordController.text = note.password;
    if (note.password == null || note.password == '') {
      verified = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(
        appBarTitle,
      )),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Visibility(
                visible: !verified,
                child: Center(
                  child: TextFormField(
                      validator: (v) =>
                      note.password != v
                          ? 'Incorrect Password'
                          : null,
                      onFieldSubmitted: (v) {
                        setState(() {
                          if (formKey.currentState.validate()) {
                            verified = !verified;
                          }
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        icon: Icon(Icons.lock),
                      )
                  ),
                ),
              ),

              Visibility(
                visible: verified,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Priority:  '),
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      child: DropdownButton(
                        items: _priorities.map((String priority) {
                          return DropdownMenuItem<String>(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                        value: getPriorityAsString(note.priority),
                        onChanged: (newPriority) {
                          setState(() {
                            updatePriorityAsInt(newPriority);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: verified,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: TextFormField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                    validator: (String title) {
                      return title.isEmpty ? 'Title cannot be Empty !!' : null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g Note 1',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                  ),
                ),
              ),
              Visibility(
                visible: verified,
                child:
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextFormField(
                  focusNode: focus,
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 20,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe in detail here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
              ),
              ),
              Visibility(
                visible: verified,
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          obscureText: _obscureText,
                          controller: _passwordController,
                          validator: (v) =>
                              v.length < 6 && v.length>0? 'Password too short' : null,
                          decoration: InputDecoration(
                            labelText: 'Password (Optional)',
                            hintText: '******',
                            icon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: _obscureText
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Visibility (
                visible: verified,
                child:
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: ButtonTheme(
                        height: 50.0,
                        child: RaisedButton(
                            elevation: 3.0,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                _save();
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                Container(
                                  width: 5.0,
                                ),
                                Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20.0),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Container(
                      width: 12,
                    ),
                    Expanded(
                      flex: 1,
                      child: ButtonTheme(
                        height: 50.0,
                        child: RaisedButton(
                          elevation: 3.0,
                          color: Colors.red,
                          onPressed: _delete,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Container(
                                width: 5.0,
                              ),
                              Text(
                                'Delete',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen(String status) {
    Navigator.pop(context, status);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void _save() async {
    note.date = DateFormat.yMMMd().format(DateTime.now());
    note.title = _titleController.text;
    note.description = _descriptionController.text;
    note.password = _passwordController.text;
    var result;
    if (note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }
    String status;
    if (result != 0) {
      status = 'Note Saved';
    } else {
      _showAlertDialogue('Status', 'Problem Saving Note');
      return;
    }
    moveToLastScreen(status);
  }

  void _delete() async {
    String status;
    if (note.id == null) {
      status = 'No Note was Deleted';
    } else {
      int result = await databaseHelper.deleteNote(note);
      if (result != 0) {
        status = 'Note Deleted';
      } else {
        _showAlertDialogue('Status', 'Problem Deleting Note');
        return;
      }
    }
    moveToLastScreen(status);
  }

  void _showAlertDialogue(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
