import 'package:flutter/material.dart';
import 'package:linguist/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'package:linguist/constants.dart';
import 'package:linguist/screens/lang_drawer.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class Conversation extends StatefulWidget {
  static String code1 = LanguageDrawer.translateFrom;
  static String code2 = LanguageDrawer.translateTo;
  static String lang1 = LanguageDrawer.langChange(code1);
  static String lang2 = LanguageDrawer.langChange(code2);
  static String text1 = "...";
  static String text2 = "...";
  @override
  _ConversationState createState() => _ConversationState();
}

enum TtsState { playing, stopped }

class _ConversationState extends State<Conversation> {
  double lang = 0;
  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  SpeechToText speech = SpeechToText();
  TtsState ttsState = TtsState.stopped;
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  void initState() {
    super.initState();
    initTts();
    initializeSpeechState();
  }

  void initializeSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  FlutterTts flutterTts;
  initTts() {
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

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg}";
      _displayError();
      //lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  Future<void> _displayError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Error!',
              style: TextStyle(
                  color: Color(0xFF094F66),
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
            ),
          ),
          content: SingleChildScrollView(
            child: Center(
              child: ListBody(
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: Color(0xFF094F66),
                    size: 60,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'No input text/audio/image found. Return to Main screen and give input.\n$lastError',
                    style: TextStyle(
                      color: Color(0xFF059796),
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: RaisedButton(
                      color: Color(0xFF059796),
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.pop(context);
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

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  Future<void> startListening({
    String translateFrom,
    String translateTo,
  }) async {
    print('started');
    lastWords = "";
    lastError = "";
    await speech.listen(
        listenFor: Duration(seconds: 60),
        localeId: translateFrom,
        cancelOnError: true,
        partialResults: true,
        onResult: (SpeechRecognitionResult result) {
          setState(() {
            lastWords = "${result.recognizedWords}";
            if (lang == 1)
              Conversation.text1 = lastWords;
            else if (lang == 2) Conversation.text2 = lastWords;
            translate(
                text: lastWords,
                translateTo: translateTo,
                translateFrom: translateFrom);
          });
          print(lastWords);
        });
  }

  Future<void> translate({
    String text,
    String translateFrom,
    String translateTo,
  }) async {
    var result = await FirebaseLanguage.instance
        .languageTranslator(translateFrom, translateTo)
        .processText(text);
    setState(() {
      if (lang == 1) {
        Conversation.text2 = result;
        if (speech.isNotListening)
          _speak(text: Conversation.text2, lang: Conversation.code2);
      } else if (lang == 2) {
        Conversation.text1 = result;
        if (speech.isNotListening)
          _speak(text: Conversation.text1, lang: Conversation.code1);
      }
    });
  }

  Future _speak({String text, String lang}) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setLanguage(lang);

    if (text != null) {
      if (text.isNotEmpty) {
        var result = await flutterTts.speak(text);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
          child: Column(
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Expanded(
                  flex: 12,
                  child: converse(
                    onPressed: () {
                      setState(() {
                        lang = 1;
                        if (!_hasSpeech || speech.isListening == false) {
                          startListening(
                            translateFrom: Conversation.code1,
                            translateTo: Conversation.code2,
                          );
                        }
                      });
                    },
                    text: Conversation.text1,
                    color: Color(0xFF51B57F),
                    language: Conversation.lang1,
                  )),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                  flex: 12,
                  child: converse(
                    onPressed: () {
                      setState(() {
                        lang = 2;
                        if (!_hasSpeech || speech.isListening == false) {
                          startListening(
                            translateFrom: Conversation.code2,
                            translateTo: Conversation.code1,
                          );
                        }
                      });
                    },
                    text: Conversation.text2,
                    color: Color(0xFF059796),
                    language: Conversation.lang2,
                  )),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Color(0xFF094F66),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            Conversation.lang1,
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
                            Conversation.lang2,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
