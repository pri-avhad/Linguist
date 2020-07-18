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
                    size: MediaQuery.of(context).size.height * 0.042,
                  ),
                ),
                Text(
                  'Error!',
                  style: TextStyle(
                      color: blue1,
                      fontSize: MediaQuery.of(context).size.height * 0.042,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [
              RaisedButton(
                color: input,
                child: Text(
                  'Okay',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.02),
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
                      height: MediaQuery.of(context).size.height * 0.007,
                    ),
                    Text(
                      'Text detection not available for $lang',
                      style: TextStyle(
                        color: blue1,
                        fontSize: MediaQuery.of(context).size.height * 0.025,
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: Consumer<CurrentLanguages>(builder: (context, current, _) {
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  height: height * 0.416,
                  width: width,
                  child: Material(
                    color: BgColor,
                    elevation: 5,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.05, height * 0.03, width * 0.05, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Linguist",
                              style: TextStyle(
                                fontSize: height * 0.04,
                                color: blue1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.032,
                            ),
                            Container(
                                height: height * 0.057,
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
                                                fontSize: height * 0.018,
                                              ),
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
                                                color: Colors.white,
                                                fontSize: height * 0.018,
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
                              height: height * 0.015,
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Container(
                                  height: height * 0.067,
                                  child: TextField(
                                    style: TextStyle(color: blue1),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          height * 0.014,
                                          width * 0.014,
                                          0,
                                          width * 0.014),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: blue1,
                                          size: height * 0.028,
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
                                        fontSize: height * 0.024,
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.028,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                iconButton(
                                    icon: Icons.camera_alt,
                                    iconSize: height * 0.0285,
                                    bgColor: blue1,
                                    radius: height * 0.036,
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
                                  iconSize: height * 0.0285,
                                  bgColor: blue1,
                                  radius: height * 0.036,
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
                                    iconSize: height * 0.0285,
                                    bgColor: blue1,
                                    radius: height * 0.036,
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => SttDrawer());
                                    }),
                                iconButton(
                                    icon: Icons.question_answer,
                                    iconSize: height * 0.0285,
                                    bgColor: blue1,
                                    radius: height * 0.036,
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Conversation();
                                      }));
                                    }),
                              ],
                            ),
                          ],
                        )),
                  ),
                ),
                Container(
                  height: height * 0.53,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(height * 0.029, width * 0.042,
                        height * 0.029, width * 0.055),
                    child: Column(
                      children: [
                        Text(
                          'Apart from directly typing out the input to be translated, Linguist provides you with these options',
                          style: TextStyle(
                              color: instructions, fontSize: height * 0.021),
                        ),
                        points(
                            'Camera button: Real time Optical Character Recognition i.e. image to text translation (available for Latin based languages only)'),
                        points(
                            'Photo button: Translating text from images/files on your device (available for Latin based languages only)'),
                        points('Mic button: Audio to text translation.'),
                        points(
                            'Conversation button: Real time speech to speech translation.'),
                        points(
                            'Real time text translation available from result screen.'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })),
        ));
  }

  Widget points(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.014,
          0, MediaQuery.of(context).size.width * 0.014),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.width * 0.012, 0, 0),
            child: Icon(
              Icons.arrow_right,
              color: instructions,
              size: MediaQuery.of(context).size.height * 0.021,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.022,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: instructions,
                  fontSize: MediaQuery.of(context).size.height * 0.021),
            ),
          ),
        ],
      ),
    );
  }
}
