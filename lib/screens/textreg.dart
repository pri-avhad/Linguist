//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:tesseract_ocr/tesseract_ocr.dart';
//import 'package:file_picker/file_picker.dart';
//
//var imageFile;
//
//class TextRecognition extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<TextRecognition> {
//  String _extractText = '';
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: const Text('Linguist'),
//        ),
//        body: Container(
//          padding: EdgeInsets.all(16),
//          child: ListView(
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                children: [
//                  FloatingActionButton(
//                    backgroundColor: Color(0xFF094F66),
//                    child: Icon(
//                      Icons.photo,
//                      color: Colors.white,
//                    ),
//                    onPressed: () async {
//                      imageFile =
//                      await FilePicker.getFilePath(type: FileType.image);
//
//                      _extractText = await TesseractOcr.extractText(imageFile,
//                          language: 'guj');
//                    },
//                  ),
//                  // It doesn't spin, because scanning hangs thread for now
//                ],
//              ),
//              SizedBox(
//                height: 16,
//              ),
//              SizedBox(
//                height: 16,
//              ),
//              Center(child: SelectableText(_extractText)),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
