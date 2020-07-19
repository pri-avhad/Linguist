import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linguist/constants.dart';
import 'package:linguist/current_model.dart';
import 'package:linguist/screens/cam.dart';
import 'package:linguist/screens/lang_drawer.dart';
import 'package:linguist/screens/result_screen.dart';
import 'package:linguist/screens/stt_drawer.dart';
import 'package:linguist/widgets.dart';
import 'package:linguist/screens/conversation.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:linguist/tile.dart';

import '../constants.dart';

var imageFile;
var firstCamera;

class MainScreen extends StatefulWidget {
  static var translatedText = '';
  static var inputText = '';
  static int result = 0;
  static int taskId = 0;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> _showMyDialog(String lang) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) {
              return AlertDialog(
                title: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Icon(
                        Icons.error,
                        color: blue1,
                        size: constraint.maxHeight * 0.0518,
                      ),
                    ),
                    Text(
                      'Error!',
                      style: TextStyle(
                          color: blue1,
                          fontSize: constraint.maxHeight * 0.0518,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                actions: [
                  RaisedButton(
                    color: input,
                    child: Text(
                      'Ok',
                      style: TextStyle(fontSize: constraint.maxHeight * 0.0251),
                    ),
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
                          height: constraint.maxHeight * 0.018,
                        ),
                        Text(
                          'Text detection not available for $lang',
                          style: TextStyle(
                            color: blue1,
                            fontSize: constraint.maxHeight * 0.0251,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
        child: Scaffold(
          drawer: new Drawer(
            child: ListView.builder(
                itemCount: languageData.length + 1,
                itemBuilder: (BuildContext context, int index) =>
                    offlineLanguageTiles(index)),
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Consumer<CurrentLanguages>(builder: (context, current, _) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.405,
                      width: constraints.maxWidth,
                      child: Material(
                        color: BgColor,
                        elevation: 5,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                constraints.maxWidth * 0.05,
                                constraints.maxHeight * 0.035,
                                constraints.maxWidth * 0.05,
                                0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: constraints.maxHeight * 0.046,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.all(0),
                                        iconSize: constraints.maxHeight * 0.04,
                                        color: blue1,
                                        icon: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            Icons.dehaze,
                                          ),
                                        ),
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                      ),
                                      Text(
                                        "Linguist",
                                        style: TextStyle(
                                          fontSize:
                                              constraints.maxHeight * 0.0356,
                                          color: blue1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.02877,
                                ),
                                Container(
                                    height: constraints.maxHeight * 0.05755,
                                    width: double.infinity,
                                    child: Consumer<CurrentLanguages>(
                                      builder: (context, current, _) {
                                        return RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          color: Color(0xFF094F66),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  current.lang1,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        constraints.maxHeight *
                                                            0.02,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Icon(
                                                  Icons.compare_arrows,
                                                  color: Colors.white,
                                                  size: constraints.maxHeight *
                                                      0.02,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  current.lang2,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        constraints.maxHeight *
                                                            0.02,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    LanguageDrawer());
                                          },
                                        );
                                      },
                                    )),
                                SizedBox(
                                  height: constraints.maxHeight * 0.01438,
                                ),
                                Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    Container(
                                      height: constraints.maxHeight * 0.069,
                                      child: TextField(
                                        style: TextStyle(
                                          color: blue1,
                                          fontSize:
                                              constraints.maxHeight * 0.024,
                                        ),
                                        cursorColor: blue1,
                                        decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: blue1, width: 1.5)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: blue1, width: 1.5)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              constraints.maxHeight * 0.014,
                                              constraints.maxWidth * 0.014,
                                              0,
                                              constraints.maxWidth * 0.014),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.search,
                                              color: blue1,
                                              size:
                                                  constraints.maxHeight * 0.027,
                                            ),
                                            onPressed: () {
                                              if (MainScreen.inputText != '') {
                                                MainScreen.taskId = 1;
                                                MainScreen.result = 1;
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return ResultScreen();
                                                }));
                                              }
                                            },
                                          ),
                                          labelText: 'Text Input',
                                          labelStyle: TextStyle(
                                            fontSize:
                                                constraints.maxHeight * 0.02,
                                            color: blue1,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          MainScreen.inputText = value;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.02877,
                                ),
                                Container(
                                  height: constraints.maxHeight * 0.071,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      iconButton(
                                          icon: Icons.camera_alt,
                                          iconSize:
                                              constraints.maxHeight * 0.025,
                                          bgColor: blue1,
                                          radius: constraints.maxHeight * 0.035,
                                          onPressed: () async {
                                            if (current.imageInput == '1') {
                                              WidgetsFlutterBinding
                                                  .ensureInitialized();
                                              final cameras =
                                                  await availableCameras();
                                              firstCamera = cameras.first;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                                  return TakePictureScreen(
                                                      camera: firstCamera);
                                                }),
                                              );
                                            } else
                                              _showMyDialog(current.lang1);
                                          }),
                                      iconButton(
                                        icon: Icons.photo,
                                        iconSize: constraints.maxHeight * 0.025,
                                        bgColor: blue1,
                                        radius: constraints.maxHeight * 0.035,
                                        onPressed: () {
                                          if (current.imageInput == '1') {
                                            MainScreen.taskId = 2;
                                            MainScreen.result = 1;
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ResultScreen();
                                            }));
                                          } else
                                            _showMyDialog(current.lang1);
                                        },
                                      ),
                                      iconButton(
                                          icon: Icons.mic,
                                          iconSize:
                                              constraints.maxHeight * 0.025,
                                          bgColor: blue1,
                                          radius: constraints.maxHeight * 0.035,
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    SttDrawer());
                                          }),
                                      iconButton(
                                          icon: Icons.question_answer,
                                          iconSize:
                                              constraints.maxHeight * 0.025,
                                          bgColor: blue1,
                                          radius: constraints.maxHeight * 0.035,
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return Conversation();
                                            }));
                                          }),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          constraints.maxWidth * 0.04,
                          constraints.maxHeight * 0.042,
                          constraints.maxWidth * 0.04,
                          constraints.maxHeight * 0.055),
                      child: Column(
                        children: [
                          Text(
                            'Apart from directly typing out the input to be translated, Linguist provides you with these options',
                            style: TextStyle(
                                color: instructions,
                                fontSize: constraints.maxHeight * 0.021),
                          ),
                          points(
                              'For faster and offline results: it is suggested to download the language models for the language you want to use from the settings.',
                              constraints.maxHeight * 0.021),
                          points(
                              'Camera button: Real time Optical Character Recognition i.e. image to text translation (available for Latin based languages only)',
                              constraints.maxHeight * 0.021),
                          points(
                              'Photo button: Translating text from images/files on your device (available for Latin based languages only)',
                              constraints.maxHeight * 0.021),
                          points('Mic button: Audio to text translation.',
                              constraints.maxHeight * 0.021),
                          points(
                              'Conversation button: Real time speech to speech translation.',
                              constraints.maxHeight * 0.021),
                          points(
                              'Real time text translation available from result screen.',
                              constraints.maxHeight * 0.021),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          })),
        ));
  }

  Widget points(String text, double size) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.014,
          0, MediaQuery.of(context).size.width * 0.014),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_right,
            color: instructions,
            size: size,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.022,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: instructions, fontSize: size),
            ),
          ),
        ],
      ),
    );
  }

  Widget offlineLanguageTiles(int index) {
    if (index == 0) {
      return Container(
          height: MediaQuery.of(context).size.height * 0.11,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraint) {
              return DrawerHeader(
                padding: EdgeInsets.fromLTRB(
                    constraint.maxWidth * 0.1,
                    constraint.maxHeight * 0.1,
                    constraint.maxWidth * 0.1,
                    constraint.maxHeight * 0.1),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Download Languages',
                      style: TextStyle(
                        fontSize: constraint.maxHeight * 0.25,
                        color: appBar,
                      )),
                ),
                decoration: BoxDecoration(color: blue1),
              );
            },
          ));
    } else {
      return tile(
        language: languageData[index - 1][0],
        languageCode: languageData[index - 1][1],
      );
    }
  }
}
