import 'package:flutter/material.dart';
import 'package:linguist/constants.dart';
import 'package:linguist/screens/main_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:provider/provider.dart';
import 'package:linguist/current_model.dart';
import 'package:linguist/screens/lang_drawer.dart';

class ResultScreen extends StatefulWidget {
  static String translateFrom = 'en';
  static String translateTo = 'en';
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

enum TtsState { playing, stopped }

class _ResultScreenState extends State<ResultScreen> {
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

  Future _speak({String text, String lang}) async {
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

  // ignore: must_call_super
  void initState() {
    super.initState();
    initTts();
    getResult();
  }

  // ignore: must_call_super
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  //dialog box which shows that input was not given and redirects to main screen
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Error!',
              style: TextStyle(
                  color: blue1, fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          content: SingleChildScrollView(
            child: Center(
              child: ListBody(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.error,
                      color: blue1,
                      size: 60,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'No text input found. Return to Main screen and give input.',
                    style: TextStyle(
                      color: input,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: RaisedButton(
                      color: input,
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MainScreen();
                        }));
                      },
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
    if (MainScreen.inputText != '')
      translate();
    else
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
        backgroundColor: BgColor,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Consumer<CurrentLanguages>(builder: (context, current, _) {
                return Column(
                  children: <Widget>[
                    Expanded(flex: 2, child: Container()),
                    Expanded(
                      flex: 12,
                      child: (MainScreen.result == 1)
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
                                      fontSize: 40,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              current.lang2,
                              style: TextStyle(color: output, fontSize: 20),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: output,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                                icon: Icon(
                                  Icons.volume_up,
                                  color: output,
                                  size: 20,
                                ),
                                onPressed: () {
                                  if (MainScreen.result == 2)
                                    _speak(
                                        text: MainScreen.translatedText,
                                        lang: current.translateId2);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Container()),
                    Expanded(
                      flex: 10,
                      child: (MainScreen.result == 1)
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
                                  Text(
                                    MainScreen.inputText,
                                    style: TextStyle(
                                      color: input,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              current.lang1,
                              style: TextStyle(color: input, fontSize: 20),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: input,
                              size: 20,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                                icon: Icon(
                                  Icons.volume_up,
                                  color: input,
                                  size: 20,
                                ),
                                onPressed: () {
                                  if (MainScreen.result == 2)
                                    _speak(
                                        text: MainScreen.inputText,
                                        lang: current.translateId1);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
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
}
