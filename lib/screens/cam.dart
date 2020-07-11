import 'dart:async';
import 'dart:io';
import 'package:linguist/constants.dart';
import 'package:linguist/current_model.dart';
import 'package:linguist/screens/result_screen.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  int stop = 0;
  String text = '';
  String translatedResult = 'Loading...';
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    // Next, initialize the controller.
    _initializeControllerFuture = _controller.initialize();
    scan();
  }

  Future<void> scan() async {
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      await _controller.takePicture(path);
      File imageFile = File(path);
      String result = await textDetect(imageFile);
      String text = await FirebaseLanguage.instance
          .languageTranslator(
              ResultScreen.translateFrom, ResultScreen.translateTo)
          .processText(result);
      setState(() {
        translatedResult = text;
        print(translatedResult);
      });
      if (stop == 0) {
        Timer(Duration(seconds: 1), () {
          scan();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    stop = 1;
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<String> textDetect(var img) async {
    String text = '';
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(img);
    TextRecognizer ourtext = FirebaseVision.instance.textRecognizer();
    VisionText readtext = await ourtext.processImage(ourImage);

    //extracting each text block in which we extract each line and in which we extract each word(element)
    for (TextBlock block in readtext.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          text = text + element.text + ' ';
        }
      }
      text = text + '\n';
    }
    ourtext.close();
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLanguages>(builder: (context, current, _) {
      return Scaffold(
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Stack(
                alignment: FractionalOffset.center,
                children: <Widget>[
                  Positioned.fill(
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller)),
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  Container(
                                    color: Colors.blueGrey,
                                    child: Text(translatedResult,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
//        floatingActionButton: FloatingActionButton(
//          backgroundColor: blue1,
//          child: Icon(
//            Icons.center_focus_weak,
//            size: 20.0,
//          ),
//          onPressed: () async {
//            setState(() {
//              translatedResult = 'LOADING...';
//            });
//            try {
//              // Ensure that the camera is initialized.
//              await _initializeControllerFuture;
//              final path = join(
//                (await getTemporaryDirectory()).path,
//                '${DateTime.now()}.png',
//              );
//
//              await _controller.takePicture(path);
//              File imageFile = File(path);
//              String result = await textDetect(imageFile);
//              String text = await FirebaseLanguage.instance
//                  .languageTranslator(
//                      current.translateId1, current.translateId2)
//                  .processText(result);
//              setState(() {
//                translatedResult = text;
//                print(translatedResult);
//              });
//            } catch (e) {
//              print(e);
//            }
//          },
//        ),
      );
    });
  }
}
