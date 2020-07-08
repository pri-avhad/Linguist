import 'package:flutter/cupertino.dart';
import 'package:linguist/constants.dart';
import 'package:linguist/screens/result_screen.dart';

class CurrentLanguages extends ChangeNotifier {
  String translateId1 = languageData[0][2];
  String translateId2 = languageData[0][2];
  String ocrId1 = languageData[0][1];
  String ocrId2 = languageData[0][1];
  String lang1 = languageData[0][0];
  String lang2 = languageData[0][0];
  assign({
    String t1,
    String t2,
    String o1,
    String o2,
    String l1,
    String l2,
  }) {
    if (t1 != null) translateId1 = t1;
    if (t2 != null) translateId2 = t2;
    if (o1 != null) ocrId1 = o1;
    if (o2 != null) ocrId2 = o2;
    if (l1 != null) lang1 = l1;
    if (l2 != null) lang2 = l2;
    ResultScreen.translateFrom = translateId1;
    ResultScreen.translateTo = translateId2;

    notifyListeners();
  }
}
