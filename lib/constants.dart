import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color appBar = Color(0xFFFFFFFF);
const Color BgColor = Color(0xFFFFFFFF);
const Color blue1 = Color(0xFF094F66);
const Color input = Color(0xFF059796);
const Color output = Color(0xFF51B57F);

const double volume = 1.0;
const double pitch = 1.0;
const double rate = 0.8;

// name,ocr code,translate code,
List<List<String>> languageData = [
  ['English', 'eng', 'en'],
  ['Kannada', 'kan', 'kn'],
  ['Marathi', 'mar', 'mr'],
  ['Gujarati', 'guj', 'gu'],
  ['Hindi', 'hin', 'hi'],
  ['Tamil', 'tam', 'tm'],
  ['Urdu', 'urd', 'ur'],
  ['Arabic', 'ara', 'ar'],
  ['French', 'fra', 'fr'],
  ['Italian', 'ita', 'it'],
  ['Portuguese', 'por', 'pt'],
  ['Romanian', 'rom', 'ro'],
  ['Spanish', 'spa', 'es'],
];
//List<List<String>> languageData = [
//  ['English', 'eng', 'en', 'en'],
//  ['Kannada', 'kan', 'kn', 'kn-IN'],
//  ['Marathi', 'mar', 'mr', 'mr-IN'],
//  ['Gujarati', 'guj', 'gu', 'gu-IN'],
//  ['Hindi', 'hin', 'hi', 'hi-IN'],
//  ['Tamil', 'tam', 'tm', 'ta-IN'],
//  ['Urdu', 'urd', 'ur', 'ur-PK'],
//  ['Arabic', 'ara', 'ar', 'ar-SA'],
//  ['French', 'fra', 'fr', 'fr-CA'],
//  ['Italian', 'ita', 'it', 'it-IT'],
//  ['Portuguese', 'por', 'pt', 'pt-BR'],
//  ['Romanian', 'rom', 'ro', 'ro-RO'],
//  ['Spanish', 'spa', 'es', 'es-US'],
//];
