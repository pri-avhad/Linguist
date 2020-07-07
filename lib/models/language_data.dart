import 'package:flutter/cupertino.dart';
import 'package:linguist/constants.dart';

class LanguageData {
  final String name;
  final String ocrCode;
  final String langCode;
  bool pressedFrom = false;
  bool pressedTo = false;
  final int index;

  LanguageData({
    @required this.name,
    @required this.ocrCode,
    @required this.langCode,
    @required this.index,
  });
}
