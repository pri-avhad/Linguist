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
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:file_picker/file_picker.dart';

var imageFile;
var firstCamera;

//Future<void> camera() async {
//
//  WidgetsFlutterBinding.ensureInitialized();
//  // Obtain a list of the available cameras on the device.
//  final cameras = await availableCameras();
//  // Get a specific camera from the list of available cameras.
//  final firstCamera = cameras.first;
//  return firstCamera;
//
//
//
//}

class MainScreen extends StatefulWidget {
  static var translatedText = '';
  static var inputText = '';
  static int result = 0;
  static int taskId = 0;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _extractText = '';

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
                                        MainScreen.taskId = 1;
                                        MainScreen.result = 1;
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ResultScreen();
                                        }));
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
                                    MainScreen.inputText = value;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Consumer<CurrentLanguages>(
                                builder: (context, current, _) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  iconButton(
                                      icon: Icons.camera_alt,
                                      iconSize: 15,
                                      bgColor: blue1,
                                      radius: 25,
                                      onPressed: () async {
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
                                        ); //TODO navigate to camera screen for real time translation
                                      }),
                                  iconButton(
                                    icon: Icons.photo,
                                    iconSize: 15,
                                    bgColor: blue1,
                                    radius: 25,
                                    onPressed: () {
                                      MainScreen.taskId = 2;
                                      MainScreen.result = 1;
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ResultScreen();
                                      }));

//                                      imageFile = await FilePicker.getFilePath(
//                                          type: FileType.image);
//                                      _extractText =
//                                          await TesseractOcr.extractText(
//                                              imageFile,
//                                              language: current.ocrId1);
//                                      print(_extractText);
                                    },
                                  ),
                                  iconButton(
                                      icon: Icons.mic,
                                      iconSize: 15,
                                      bgColor: blue1,
                                      radius: 25,
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) => SttDrawer());
                                      }),
                                  iconButton(
                                      icon: Icons.question_answer,
                                      iconSize: 15,
                                      bgColor: blue1,
                                      radius: 25,
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Conversation();
                                        }));
                                      }),
                                ],
                              );
                            }),
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
