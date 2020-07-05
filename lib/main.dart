import 'package:flutter/material.dart';
import 'package:linguist/screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: MainScreen(),
        //theme: ThemeData(),
      ),
    );
  }
}
