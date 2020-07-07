import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linguist/constants.dart';
import 'package:linguist/widgets.dart';
//import 'result_screen.dart';
//import 'package:linguist/stt_drawer.dart';
//import 'dart:io';
import 'package:linguist/models/language_data.dart';

class MainScreen extends StatefulWidget {
  static String textFieldInput = '';
  static String translateTo = 'en';
  static String translateFrom = 'en';
  static var translatedText = '...';
  static var inputText = '...';
  static int result = 0;
  static int taskId;
  static String list1Value = MainScreen.langChange(MainScreen.translateFrom);
  static String list2Value = MainScreen.langChange(MainScreen.translateTo);
//  static String list1Value = 'englis';
//  static String list2Value = 'englis';

  static List<LanguageData> langContents;

  static String langChange(String code) {
    String changedLang;
    for (int i = 0; i <= langContents.length; i++) {
      if (code == langContents[i].langCode) changedLang = langContents[i].name;
    }
    return changedLang;
  }

  setState() {
    list1Value = MainScreen.langChange(MainScreen.translateFrom);
    list2Value = MainScreen.langChange(MainScreen.translateTo);
  }

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    initialiseLanguages();
    super.initState();
  }

  void initialiseLanguages() {
    print('starting');
    for (int i = 0; i < kLanguages.length; i++) {
      LanguageData temporary = new LanguageData(
          name: kLanguages[i],
          ocrCode: kOcrCodes[i],
          langCode: kTranslateCodes[i],
          index: i);
      //print(temporary);
      print(temporary.name);
      if (temporary == null)
        print("is nullll error");
      else
        MainScreen.langContents.add(temporary);

//      MainScreen.langContents.add(LanguageData(
//          name: kLanguages[i],
//          ocrCode: kOcrCodes[i],
//          langCode: kTranslateCodes[i],
//          index: i));
    }
  }

  Widget buildLanguageDrawer(BuildContext context) {
    initialiseLanguages();

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setStateOfDrawer) {
        void changeFromActiveLanguageState(int index) {
          setStateOfDrawer(() {
            for (int i = 0; i <= MainScreen.langContents.length; i++) {
              if (i == index) {
                MainScreen.langContents[index].pressedFrom = true;
              } else
                MainScreen.langContents[index].pressedFrom = false;
            }
          });
          this.setState(() {
            MainScreen.translateFrom = MainScreen.langContents[index].langCode;
            MainScreen.langChange(MainScreen.translateFrom);
          });
        }

        void changeToActiveLanguageState(int index) {
          setStateOfDrawer(() {
            for (int i = 0; i <= MainScreen.langContents.length; i++) {
              if (i == index) {
                MainScreen.langContents[index].pressedTo = true;
              } else
                MainScreen.langContents[index].pressedTo = false;
            }
          });
          this.setState(() {
            MainScreen.translateTo = MainScreen.langContents[index].langCode;
            MainScreen.langChange(MainScreen.translateTo);
          });
        }

        List<Widget> getFromDrawer() {
          List<Widget> languageElements = [];

          for (int i = 0; i <= kLanguages.length; i++) {
            languageElements.add(
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  MainScreen.langContents[i].name,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: !MainScreen.langContents[i].pressedFrom
                          ? Colors.white
                          : Colors.black),
                ),
                color: MainScreen.langContents[i].pressedFrom ? input : blue1,
                onPressed: () {
                  print('${MainScreen.langContents[i].name} pressed');
                  changeFromActiveLanguageState(i);
                },
              ),
            );
          }
          return languageElements;
        }

        List<Widget> getToDrawer() {
          List<Widget> languageElements = [];

          for (int i = 0; i <= kLanguages.length; i++) {
            languageElements.add(
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Text(
                  MainScreen.langContents[i].name,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: !MainScreen.langContents[i].pressedTo
                          ? Colors.white
                          : Colors.black),
                ),
                color: MainScreen.langContents[i].pressedTo ? input : blue1,
                onPressed: () {
                  print('${MainScreen.langContents[i].name} pressedTo');
                  changeToActiveLanguageState(i);
                },
              ),
            );
          }
          return languageElements;
        }

        return Container(
          color: Color(0xff757575),
          child: Container(
            decoration: BoxDecoration(
              color: blue1,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Text(
                      'Languages',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: getFromDrawer(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 15.0, 0, 15),
                              child: Icon(
                                Icons.compare_arrows,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: getToDrawer(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: BgColor,
        body: SafeArea(
          child: Column(
            children: [
              Material(
                color: appBar,
                elevation: 8,
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Linguist',
                      style: TextStyle(
                        color: blue1,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30),
                    Container(
                      height: 40,
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: blue1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Text(
                                MainScreen.list1Value,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.compare_arrows,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                MainScreen.list2Value,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          setState(
                            () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return buildLanguageDrawer(context);
                                  });
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: Material(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        elevation: 2,
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            TextField(
                              style: TextStyle(color: blue1),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 5, 0, 5),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: blue1,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      MainScreen.result = 1;
                                      MainScreen.taskId = 3;
//                                      Navigator.push(context,
//                                          MaterialPageRoute(builder: (context) {
//                                            return ResultScreen();
//                                          }));
                                    });
                                  },
                                ),
                                labelText: 'Text Input',
                                labelStyle: TextStyle(
                                  color: blue1,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                MainScreen.textFieldInput = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            iconButton(
                                radius: 25,
                                iconSize: 20,
                                bgColor: input,
                                icon: Icons.camera_alt,
                                onPressed: () {
                                  setState(() {
                                    MainScreen.taskId = 1;
                                    MainScreen.result = 1;
//                                    Navigator.push(context,
//                                        MaterialPageRoute(builder: (context) {
//                                          return ResultScreen();
//                                        }));
                                  });
                                }),
                            iconButton(
                              iconSize: 35,
                              radius: 38,
                              bgColor: blue1,
                              icon: Icons.mic,
                              onPressed: () {
//                                showModalBottomSheet(
//                                  context: context,
//                                  builder: (context) => SttDrawer(),
//                                );
                              },
                            ),
                            iconButton(
                              iconSize: 20,
                              bgColor: input,
                              radius: 25,
                              icon: Icons.photo,
                              onPressed: () {
                                setState(() {
                                  MainScreen.taskId = 2;
                                  MainScreen.result = 1;
//                                  Navigator.push(context,
//                                      MaterialPageRoute(builder: (context) {
//                                        return ResultScreen();
//                                      }));
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
