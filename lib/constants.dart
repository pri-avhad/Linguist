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

List<List> offlineLangSet = [
  ['English', 'en', 'en-US'],
  ['French', 'fr', 'fr-FR'],
  ['Italian', 'it', 'it-IT'],
  ['Portuguese', 'pt', 'pt-PT'], //ToDo check portuguese code
  ['Romanian', 'ro', 'ro-RO'],
  ['Spanish', 'es', 'es-ES'],
  ['Dutch', 'nl', 'nl-NL'],
  ['Finnish', 'fi', 'fi-FI'],
  ['German', 'de', 'de-DE'],
  ['Polish', 'pl', 'pl-PL'],
  ['Kannada', 'kn', 'kn-IN'],
  ['Marathi', 'mr', 'mr-IN'],
  ['Gujarati', 'gu', 'gu-IN'],
  ['Hindi', 'hi', 'hi-IN'],
  ['Tamil', 'tm', 'ta-IN'], //ToDo check tamil code
  ['Urdu', 'ur', 'ur-PK'], //ToDo check urdu code
  ['Arabic', 'ar', 'ar-SA'],
];
