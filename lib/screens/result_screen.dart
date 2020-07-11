import 'package:flutter/material.dart';
import 'package:linguist/constants.dart';
import 'package:linguist/screens/main_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:provider/provider.dart';
import 'package:linguist/current_model.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:linguist/screens/lang_drawer.dart';
import 'package:image_cropper/image_cropper.dart';
import 'main_screen.dart';
import 'package:linguist/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ResultScreen extends StatefulWidget {
  static String translateFrom = 'en';
  static String translateTo = 'en';
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

enum TtsState { playing, stopped }

class _ResultScreenState extends State<ResultScreen> {
  bool _isEditingText = false;
  TextEditingController _editingController;
  FlutterTts flutterTts;
  String language;
  String text = '';
  var inputText;

  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  Future initTts() async {
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future speak({String text, String lang}) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    if ((await flutterTts.isLanguageAvailable(lang))) {
      await flutterTts.setLanguage(lang);
      print('there');
    } else
      await flutterTts.setLanguage('en');

    if (text != null) {
      if (text.isNotEmpty) {
        var result = await flutterTts.speak(text);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  void initState() {
    super.initState();
    initTts();
    getResult();
    _editingController = TextEditingController(text: MainScreen.inputText);
  }

  void dispose() {
    flutterTts.stop();
    _editingController.dispose();
    super.dispose();
  }

  Future<void> cropImage(var img) async {
    var cropped = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: blue1,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: blue1,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (cropped != null) {
      setState(() {
        imageFile = cropped;
      });
      await textDetect(imageFile);
    } else
      await _showMyDialog();
  }

  Future<void> textDetect(var img) async {
    //using Firebase ML vision kit to identify text blocks from image
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
    }
    ourtext.close();
    MainScreen.inputText = text;
    if (MainScreen.inputText != '')
      await translate();
    else
      _showMyDialog();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: Icon(
                  Icons.error,
                  color: blue1,
                  size: 30,
                ),
              ),
              Text(
                'Error!',
                style: TextStyle(
                    color: blue1, fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            RaisedButton(
              color: input,
              child: Text('Okay'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MainScreen();
                }));
              },
            ),
          ],
          content: SingleChildScrollView(
            child: Center(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'No text input found. \nReturn to Main screen to give an input.',
                    style: TextStyle(
                      color: blue1,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> translate() async {
    String text = await FirebaseLanguage.instance
        .languageTranslator(
            ResultScreen.translateFrom, ResultScreen.translateTo)
        .processText(MainScreen.inputText);
    setState(() {
      MainScreen.translatedText = text;
      MainScreen.result = 2;
    });
  }

  Future<void> getResult() async {
    if (MainScreen.taskId == 1) {
      if (MainScreen.inputText != '')
        translate();
      else
        await _showMyDialog();
    } else if (MainScreen.taskId == 2) {
      imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          cropImage(imageFile);
        });
      } else {
        await _showMyDialog();
      }
    } else
      //if image input is empty then displays a dialog box which redirects to main screen
      await _showMyDialog();
  }

  void backButton() {
    MainScreen.result = 0;
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MainScreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        backButton();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: BgColor,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Consumer<CurrentLanguages>(builder: (context, current, _) {
                return Column(
                  children: <Widget>[
                    Expanded(flex: 2, child: Container()),
                    Expanded(
                      flex: 15,
                      child: result(
                          color: output,
                          output: (MainScreen.result == 1)
                              ? Container(
                                  height: double.infinity,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(output),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      Text(
                                        MainScreen.translatedText,
                                        style: TextStyle(
                                          color: output,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          onPressedSpeak: () {
                            setState(() {
                              if (MainScreen.result == 2) {
                                speak(
                                    text: MainScreen.translatedText,
                                    lang: current.translateId2);
                              }
                            });
                          },
                          title: 'Translated text:',
                          language: current.lang2),
                    ),
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 15,
                      child: result(
                          color: input,
                          output: (MainScreen.result == 1)
                              ? Container(
                                  height: double.infinity,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(input),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  child: ListView(
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      _editTitleTextField(),
                                    ],
                                  ),
                                ),
                          onPressedSpeak: () {
                            if (MainScreen.result == 2)
                              speak(
                                  text: MainScreen.inputText,
                                  lang: current.translateId1);
                          },
                          title: 'Tap to edit:',
                          language: current.lang1),
                    ),
                    Expanded(flex: 1, child: Container()),
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: blue1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                current.lang1,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.compare_arrows,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                current.lang2,
                                textAlign: TextAlign.right,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => LanguageDrawer());
                        },
                      ),
                    ),
                  ],
                );
              })),
        ),
      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return TextField(
        keyboardType: TextInputType.text,
        maxLines: null,
        cursorColor: input,
        style: TextStyle(
          color: input,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (value) {
          setState(() {
            MainScreen.inputText = value;
            MainScreen.taskId = 1;
            translate();
          });
        },
        onSubmitted: (newValue) {
          setState(() {
            MainScreen.inputText = newValue;
            _isEditingText = false;
          });
        },
        autofocus: false,
        controller: _editingController,
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          MainScreen.inputText,
          style: TextStyle(
            color: input,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ));
  }
}
