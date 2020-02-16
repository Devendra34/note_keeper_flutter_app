import 'package:flutter/material.dart';
import 'package:note_keeper/screens/note_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Keeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

