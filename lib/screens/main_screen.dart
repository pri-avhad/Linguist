import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linguist/screens/conversation.dart';
import 'package:linguist/widgets.dart';
import 'dart:io';

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
  static String langChange(String code) {
    if (code == 'en')
      return 'English';
    else if (code == 'es')
      return 'Spanish';
    else if (code == 'it')
      return 'Italian';
    else if (code == 'pt')
      return 'Portuguese';
    else if (code == 'fr')
      return 'French';
    else if (code == 'ro') return 'Romanian';
  }

  setState() {
    list1Value = MainScreen.langChange(MainScreen.translateFrom);
    list2Value = MainScreen.langChange(MainScreen.translateTo);
  }

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<bool> pressedFrom = [false, false, false, false, false, false];
  List<bool> pressedTo = [false, false, false, false, false, false];
  //PermissionsService handler = new PermissionsService();

  Color blue1 = Color(0xFF094F66);
  Color input = Color(0xFF059796);
  Color output = Color(0xFF51B57F);
  Widget buildLanguageDrawer(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setStateOfDrawer) {
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
                          children: <Widget>[
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedFrom[0]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedFrom[0] ? input : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedFrom = [
                                      true,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateFrom = 'en';
                                    MainScreen.list1Value =
                                        MainScreen.langChange(
                                            MainScreen.translateFrom);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Spanish',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedFrom[1]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedFrom[1] ? input : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedFrom = [
                                      false,
                                      true,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateFrom = 'es';
                                    MainScreen.list1Value =
                                        MainScreen.langChange(
                                            MainScreen.translateFrom);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'French',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedFrom[2]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedFrom[2] ? input : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedFrom = [
                                      false,
                                      false,
                                      true,
                                      false,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateFrom = 'fr';
                                    MainScreen.list1Value =
                                        MainScreen.langChange(
                                            MainScreen.translateFrom);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Italian',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedFrom[3]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedFrom[3] ? input : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedFrom = [
                                      false,
                                      false,
                                      false,
                                      true,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateFrom = 'it';
                                    MainScreen.list1Value =
                                        MainScreen.langChange(
                                            MainScreen.translateFrom);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Portuguese',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedFrom[4]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedFrom[4] ? input : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedFrom = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      true,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateFrom = 'pt';
                                    MainScreen.list1Value =
                                        MainScreen.langChange(
                                            MainScreen.translateFrom);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Romanian',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedFrom[5]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedFrom[5] ? input : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedFrom = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      true
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateFrom = 'ro';
                                    MainScreen.list1Value =
                                        MainScreen.langChange(
                                            MainScreen.translateFrom);
                                  });
                                })
                          ],
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
                          children: <Widget>[
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedTo[0]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedTo[0] ? output : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedTo = [
                                      true,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateTo = 'en';
                                    MainScreen.list2Value =
                                        MainScreen.langChange(
                                            MainScreen.translateTo);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Spanish',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedTo[1]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedTo[1] ? output : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedTo = [
                                      false,
                                      true,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateTo = 'es';
                                    MainScreen.list2Value =
                                        MainScreen.langChange(
                                            MainScreen.translateTo);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'French',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedTo[2]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedTo[2] ? output : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedTo = [
                                      false,
                                      false,
                                      true,
                                      false,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateTo = 'fr';
                                    MainScreen.list2Value =
                                        MainScreen.langChange(
                                            MainScreen.translateTo);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Italian',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedTo[3]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedTo[3] ? output : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedTo = [
                                      false,
                                      false,
                                      false,
                                      true,
                                      false,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateTo = 'it';
                                    MainScreen.list2Value =
                                        MainScreen.langChange(
                                            MainScreen.translateTo);
                                  });
                                }),
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  'Portuguese',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: !pressedTo[4]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                color: pressedTo[4] ? output : blue1,
                                onPressed: () {
                                  setStateOfDrawer(() {
                                    pressedTo = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      true,
                                      false
                                    ];
                                  });
                                  this.setState(() {
                                    MainScreen.translateTo = 'pt';
                                    MainScreen.list2Value =
                                        MainScreen.langChange(
                                            MainScreen.translateTo);
                                  });
                                }),
                            FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                'Romanian',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: !pressedTo[5]
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              color: pressedTo[5] ? output : blue1,
                              onPressed: () {
                                setStateOfDrawer(() {
                                  pressedTo = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    true
                                  ];
                                });
                                this.setState(() {
                                  MainScreen.translateTo = 'ro';
                                  MainScreen.list2Value = MainScreen.langChange(
                                      MainScreen.translateTo);
                                });
                              },
                            )
                          ],
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Material(
                color: Colors.white,
                elevation: 8,
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Linguist',
                      style: TextStyle(
                        color: Color(0xFF094F66),
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
                        color: Color(0xFF094F66),
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
                              style: TextStyle(color: Color(0xFF094F66)),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 5, 0, 5),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Color(0xFF094F66),
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                ),
                                labelText: 'Text Input',
                                labelStyle: TextStyle(
                                  color: Color(0xFF094F66),
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
                                bgColor: Color(0xFF059796),
                                icon: Icons.camera_alt,
                                onPressed: () {}),
                            iconButton(
                              iconSize: 35,
                              radius: 38,
                              bgColor: Color(0xFF094F66),
                              icon: Icons.mic,
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Conversation();
                                }));
                              },
                            ),
                            iconButton(
                              iconSize: 20,
                              bgColor: Color(0xFF059796),
                              radius: 25,
                              icon: Icons.photo,
                              onPressed: () {},
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
