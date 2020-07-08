import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:linguist/current_model.dart';
import 'screens/cam.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return CurrentLanguages();
      },
      child: MaterialApp(
        home: MainScreen(),
      ),
    );
  }
}
