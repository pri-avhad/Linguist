import 'dart:async';
import 'dart:io';
import 'package:linguist/constants.dart';
import 'package:linguist/current_model.dart';
import 'package:provider/provider.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

// A screen that allows users to take a picture using a given camera.
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
  String translatedOcrResult = 'Click to scan';
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> getOcr(image, language) async {
      String _extractText;
      print('starting');
      _extractText = await TesseractOcr.extractText(
        image,
        language: language,
      );
      print(_extractText);
      return _extractText;
    }

    return Consumer<CurrentLanguages>(builder: (context, current, _) {
      return Scaffold(
//        appBar: AppBar(),
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
                        height: 200.0,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  Container(
                                    color: Colors.white,
                                    child: Text(translatedOcrResult,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.cyan,
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: blue1,
          child: Icon(
            Icons.camera_alt,
            size: 20.0,
          ),
          onPressed: () async {
            setState(() {
              translatedOcrResult = 'LOADING...';
            });
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;
              final path = join(
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );

              await _controller.takePicture(path);

              print(path);
              String ocrResult = await getOcr(path, current.ocrId1);
              String text = await FirebaseLanguage.instance
                  .languageTranslator(
                      current.translateId1, current.translateId2)
                  .processText(ocrResult);
//                setState(() {
//                  MainScreen.translatedText = text;
//                  MainScreen.result = 2;
//                });
              setState(() {
                translatedOcrResult = text;
                print(translatedOcrResult);
              });

              // If the picture was taken, display it on a new screen.
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => DisplayPictureScreen(imagePath: path),
//              ),
//            );
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
        ),
      );
    });
  }
}
