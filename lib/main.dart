import 'package:flutter/material.dart';
import 'input_page.dart';

void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: InputPage(),
    );
  }
}
