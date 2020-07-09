import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linguist/current_model.dart';
import 'package:provider/provider.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

var imageFile;

//// A widget that displays the picture taken by the user.
//class DisplayPictureScreen extends StatelessWidget {
//  final String imagePath;
//
//  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
////    TextRecognition(
////      image: imagePath,
////    );
//
//    return Scaffold(
//      appBar: AppBar(title: Text('Display the Picture')),
//      // The image is stored as a file on the device. Use the `Image.file`
//      // constructor with the given path to display the image.
//      body: Column(
//        children: <Widget>[
//          Expanded(child: Image.file(File(imagePath))),
//          Expanded(
//            child: Text(TextRecognition.extractedText ?? 'loading'),
//          ),
//        ],
//      ),
//    );
//  }
//}

class TextRecognition extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  static String extractedText;
  final image;
  TextRecognition({this.image});
}

class _MyAppState extends State<TextRecognition> {
  String _extractText = 'loading...';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          Consumer(builder: (context, current, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: Color(0xFF094F66),
                  child: Icon(
                    Icons.photo,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    print(Provider.of<CurrentLanguages>(context).ocrId1);
                    print('starting');
//                      imageFile =
//                          await FilePicker.getFilePath(type: FileType.image);
                    _extractText = await TesseractOcr.extractText(
                      widget.image,
                      language: Provider.of<CurrentLanguages>(context).ocrId1,
                    );
                    setState(() {
                      TextRecognition.extractedText = _extractText;
                    });
                  },
                ),
                // It doesn't spin, because scanning hangs thread for now
              ],
            );
          }),
          SizedBox(
            height: 16,
          ),
          Expanded(child: Image.file(File(widget.image))),
          Center(child: SelectableText(_extractText)),
        ],
      ),
    );
  }
}
