import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linguist/constants.dart';
import 'package:linguist/screens/lang_drawer.dart';
import 'package:linguist/widgets.dart';
import 'package:linguist/screens/conversation.dart';

class MainScreen extends StatefulWidget {
  static String textFieldInput = '';
  static var translatedText = '...';
  static var inputText = '...';
  static int result = 0;
  static int taskId;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
                Expanded(
                  flex: 2,
                  child: Material(
                    color: BgColor,
                    elevation: 5,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 35, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Linguist",
                              style: TextStyle(
                                fontSize: 30,
                                color: blue1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              width: double.infinity,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                color: Color(0xFF094F66),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        LanguageDrawer.langChange(
                                            LanguageDrawer.translateFrom),
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
                                        LanguageDrawer.langChange(
                                            LanguageDrawer.translateTo),
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
                            SizedBox(
                              height: 10,
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              children: [
                                TextField(
                                  style: TextStyle(color: blue1),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 5, 0, 5),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.mic,
                                        color: blue1,
                                        size: 20,
                                      ),
                                      onPressed: () {},
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
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                iconButton(
                                    icon: Icons.camera_alt,
                                    iconSize: 15,
                                    bgColor: blue1,
                                    radius: 25,
                                    onPressed: () {}),
                                iconButton(
                                    icon: Icons.question_answer,
                                    iconSize: 15,
                                    bgColor: blue1,
                                    radius: 25,
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Conversation();
                                      }));
                                    }),
                                iconButton(
                                    icon: Icons.photo,
                                    iconSize: 15,
                                    bgColor: blue1,
                                    radius: 25,
                                    onPressed: () {}),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
              ],
            ),
          ),
        ));
  }
}
