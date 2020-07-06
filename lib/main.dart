import 'package:flutter/material.dart';
import 'package:linguist/screens/conversation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: Conversation(),
        //theme: ThemeData(),
      ),
    );
  }
}
