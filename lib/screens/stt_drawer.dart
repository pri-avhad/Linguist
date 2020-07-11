import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:linguist/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:linguist/screens/main_screen.dart';
import 'package:linguist/screens/result_screen.dart';
import 'package:linguist/constants.dart';
import 'package:linguist/current_model.dart';
import 'package:provider/provider.dart';

class SttDrawer extends StatefulWidget {
  @override
  _SttDrawerState createState() => _SttDrawerState();
}

class _SttDrawerState extends State<SttDrawer> {
  bool hasSpeech = false;
  double level = 0.0;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  SpeechToText speech = SpeechToText();
  @override
  void initState() {
    super.initState();
    initializeSpeechState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initializeSpeechState() async {
    hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (!mounted) return;
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg}";
      _displayError();
    });
  }

  Future<void> _displayError() async {
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
                Navigator.pop(context);
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
                    'No input found. \nReturn to Main screen and give input.\n$lastError',
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

  void statusListener(String status) {
    print(
        "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  void startListening(String translateFrom) {
    print('started');
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 60),
        localeId: translateFrom,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
      //lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
    print(lastWords);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<CurrentLanguages>(builder: (context, current, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Audio Input',
                        style: TextStyle(
                          color: blue1,
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 3,
                    child: (speech.isListening == true)
                        ? Center(
                            child: Image(
                              image: AssetImage('images/soundwaves.gif'),
                              height: double.infinity,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            child: Center(
                              child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  Text(
                                    lastWords,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 25,
                                        color: input),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: iconButton(
                          radius: 25,
                          iconSize: 20,
                          bgColor: input,
                          icon: Icons.mic_none,
                          onPressed: () {
                            setState(() {
                              if (!hasSpeech || speech.isListening == false) {
                                startListening(current.lang1);
                              }
                            });
                          },
                        )),
                        Expanded(
                          child: iconButton(
                            iconSize: 20,
                            bgColor: output,
                            radius: 25,
                            icon: Icons.search,
                            onPressed: () {
                              if (lastWords != '') {
                                setState(
                                  () {
                                    MainScreen.inputText = lastWords;
                                    MainScreen.taskId = 1;
                                    MainScreen.result = 1;
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ResultScreen();
                                    }));
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            })),
      ),
    );
  }
}
