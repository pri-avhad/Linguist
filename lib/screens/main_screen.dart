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
                      'Text detection not available for $lang',
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
        });
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
              child: Consumer<CurrentLanguages>(builder: (context, current, _) {
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Material(
                    color: BgColor,
                    elevation: 5,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                              height: 20,
                            ),
                            Container(
                                height: 40,
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
                                                  color: Colors.white),
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
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                        Icons.search,
                                        color: blue1,
                                        size: 20,
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
                                      fontSize: 17,
                                      color: blue1,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    MainScreen.inputText = value;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                iconButton(
                                    icon: Icons.camera_alt,
                                    iconSize: 20,
                                    bgColor: blue1,
                                    radius: 25,
                                    onPressed: () async {
                                      if (current.imageInput == '1') {
                                        WidgetsFlutterBinding
                                            .ensureInitialized();
                                        // Obtain a list of the available cameras on the device.
                                        final cameras =
                                            await availableCameras();
                                        // Get a specific camera from the list of available cameras.
                                        firstCamera = cameras.first;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return TakePictureScreen(
                                                camera: firstCamera);
                                          }),
                                        );
                                      } else
                                        _showMyDialog(current.lang1);
                                    }),
                                iconButton(
                                  icon: Icons.photo,
                                  iconSize: 20,
                                  bgColor: blue1,
                                  radius: 25,
                                  onPressed: () {
                                    if (current.imageInput == '1') {
                                      MainScreen.taskId = 2;
                                      MainScreen.result = 1;
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ResultScreen();
                                      }));
                                    } else
                                      _showMyDialog(current.lang1);
                                  },
                                ),
                                iconButton(
                                    icon: Icons.mic,
                                    iconSize: 20,
                                    bgColor: blue1,
                                    radius: 25,
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => SttDrawer());
                                    }),
                                iconButton(
                                    icon: Icons.question_answer,
                                    iconSize: 20,
                                    bgColor: blue1,
                                    radius: 25,
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Conversation();
                                      }));
                                    }),
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Text(
                          'Apart from directly typing out the input to be translated, Linguist provides you with these options',
                          style: TextStyle(color: instructions, fontSize: 18),
                        ),
                        points(
                            'Camera button: Real time Optical Character Recognition i.e. image to text translation (available for Latin based languages only)'),
                        points(
                            'Photo button: Translating text from images/files on your device (available for Latin based languages only)'),
                        points('Mic button: Audio to text translation.'),
                        points(
                            'Conversation button: Real time speech to speech translation.'),
                        Text(
                          'Real time text translation available from result screen.',
                          style: TextStyle(color: instructions, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
        ));
  }
}

Widget points(String text) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Icon(
            Icons.arrow_right,
            color: instructions,
            size: 15,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: instructions, fontSize: 18),
          ),
        ),
      ],
    ),
  );
}
