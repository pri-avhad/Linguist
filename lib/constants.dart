import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color appBar = Color(0xFFFFFFFF);
const Color BgColor = Color(0xFFFFFFFF);
const Color blue1 = Color(0xFF094F66);
const Color input = Color(0xFF059796);
const Color output = Color(0xFF51B57F);
const Color instructions = Color(0xFF959595);

const double volume = 1.0;
const double pitch = 1.0;
const double rate = 0.8;

// name,ocr code,translate code,
List<List<String>> languageData = [
  ['English', 'en', '1'],
  ['French', 'fr', '1'],
  ['Italian', 'it', '1'],
  ['Portuguese', 'pt', '1'],
  ['Romanian', 'ro', '1'],
  ['Spanish', 'es', '1'],
  ['Dutch', 'nl', '1'],
  ['Finnish', 'fi', '1'],
  ['German', 'de', '1'],
  ['Polish', 'pl', '1'],
  ['Kannada', 'kn', '0'],
  ['Marathi', 'mr', '0'],
  ['Gujarati', 'gu', '0'],
  ['Hindi', 'hi', '0'],
  ['Tamil', 'tm', '0'],
  ['Urdu', 'ur', '0'],
  ['Arabic', 'ar', '0'],
];