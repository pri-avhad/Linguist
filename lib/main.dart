import 'package:flutter/material.dart';
import 'package:linguist/constants.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:linguist/current_model.dart';
import 'screens/cam.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

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

//    final ModelManager modelManager = FirebaseLanguage.instance.modelManager();
//    for (int i = 0; i < languageData.length; i++)
//      modelManager.downloadModel(languageData[i][2]);
