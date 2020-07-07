//import 'package:flutter/material.dart';
//import 'constants.dart';
//
//// name,ocr code,translate code,
//List<List<String>> languageData = [
//  ['Arabic', 'ara', 'ar'],
//  ['English', 'eng', 'en'],
//  ['French', 'fra', 'fr'],
//  ['Gujarati', 'guj', 'gu'],
//  ['Hindi', 'hin', 'hi'],
//  ['Italian', 'ita', 'it'],
//  ['Kannada', 'kan', 'kn'],
//  ['Marathi', 'mar', 'mr'],
//  ['Portuguese', 'por', 'pt'],
//  ['Romanian', 'rom', 'ro'],
//  ['Spanish', 'spa', 'es'],
//  ['Tamil', 'tam', 'tm'],
//  ['Urdu', 'urd', 'ur'],
//];
//Widget buildLanguageDrawer(BuildContext context) {
//  return StatefulBuilder(
//    builder: (BuildContext context, StateSetter setStateOfDrawer) {
//      List<Widget> listElement;
//      List<bool> pressedFrom;
//      List<bool> pressedTo;
//      for (int i = 0; i < languageData.length; i++) pressedFrom[i] = false;
//      for (int i = 0; i < languageData.length; i++) pressedTo[i] = false;
//      void changeFromActiveLanguageState(int index) {
//        setStateOfDrawer(() {
//          for (int i = 0; i < languageData.length; i++) {
//            if (i == index)
//              pressedFrom[i] = true;
//            else
//              pressedFrom[i] = false;
//          }
//        });
//        setState(() {
//          MainScreen.translateFrom = languageData[index][2];
//          MainScreen.langChange(MainScreen.translateFrom);
//        });
//      }
//      void changeToActiveLanguageState(int index) {
//        setStateOfDrawer(() {
//          for (int i = 0; i < languageData.length; i++) {
//            if (i == index) {
//              pressedTo[i] = true;
//            } else
//              pressedTo[i] = false;
//          }
//        });
//        setState(() {
//          MainScreen.translateTo = languageData[index][2];
//          MainScreen.langChange(MainScreen.translateTo);
//        });
//      }
//
//      List<Widget> getFromDrawer() {
//        for (int i = 0; i < languageData.length; i++) {
//          listElement[i] = FlatButton(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(8.0)),
//            child: Text(
//              languageData[i][0],
//              style: TextStyle(
//                  fontSize: 18.0,
//                  color: pressedFrom[i] ? Colors.black : Colors.white),
//            ),
//            color: pressedFrom[i] ? input : blue1,
//            onPressed: () {
//              print('${languageData[i][0]} pressed');
//              if(MainScreen.result==1)
//              changeFromActiveLanguageState(i);
//            },
//          );
//        }
//        return listElement;
//      }
//
//      List<Widget> getToDrawer() {
//        for (int i = 0; i < languageData.length; i++) {
//          listElement[i] = FlatButton(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(8.0)),
//            child: Text(
//              languageData[i][0],
//              style: TextStyle(
//                  fontSize: 18.0,
//                  color: pressedTo[i] ? Colors.black : Colors.white),
//            ),
//            color: pressedTo[i] ? input : blue1,
//            onPressed: () {
//              print('${languageData[i][0]} pressedTo');
//              changeToActiveLanguageState(i);
//            },
//          );
//        }
//        return listElement;
//      }
//
//      return Container(
//        color: Color(0xff757575),
//        child: Container(
//          decoration: BoxDecoration(
//            color: blue1,
//            borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(20.0),
//                topRight: Radius.circular(20.0)),
//          ),
//          child: ListView(
//            scrollDirection: Axis.vertical,
//            children: [
//              Padding(
//                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
//                  child: Text(
//                    'Languages',
//                    style: TextStyle(
//                        fontSize: 30,
//                        color: Colors.white,
//                        fontWeight: FontWeight.w600),
//                  )),
//              Padding(
//                padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Expanded(
//                      flex: 3,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: getFromDrawer(),
//                      ),
//                    ),
//                    Expanded(
//                      flex: 1,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15),
//                            child: Icon(
//                              Icons.compare_arrows,
//                              color: Colors.white,
//                              size: 16,
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                    Expanded(
//                      flex: 3,
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: getToDrawer(),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        ),
//      );
//    },
//  );
//}
//
//String langChange(String code) {
//  for (int i = 0; i < languageData.length; i++) {
//    if (code == languageData[i][2]) return languageData[i][0];
//  }
//}
