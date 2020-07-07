import 'package:flutter/material.dart';
import 'package:linguist/constants.dart';

class LanguageDrawer extends StatefulWidget {
  static String translateTo = 'en';
  static String translateFrom = 'en';
  static String langChange(String code) {
    for (int i = 0; i < languageData.length; i++) {
      if (code == languageData[i][2]) return languageData[i][0];
    }
  }

  @override
  _LanguageDrawerState createState() => _LanguageDrawerState();
}

class _LanguageDrawerState extends State<LanguageDrawer> {
  List<bool> pressedFrom = new List(languageData.length);
  List<bool> pressedTo = new List(languageData.length);

  // ignore: must_call_super
  void initState() {
    for (int i = 0; i < languageData.length; i++) pressedFrom[i] = false;
    for (int i = 0; i < languageData.length; i++) pressedTo[i] = false;
  }

  @override
  Widget build(BuildContext context) {
    void changeFromActiveLanguageState(int index) {
      setState(() {
        for (int i = 0; i < languageData.length; i++) {
          if (i == index)
            pressedFrom[i] = true;
          else
            pressedFrom[i] = false;
        }
        LanguageDrawer.translateFrom = languageData[index][2];
        LanguageDrawer.langChange(LanguageDrawer.translateFrom);
      });
    }

    void changeToActiveLanguageState(int index) {
      setState(() {
        for (int i = 0; i < languageData.length; i++) {
          if (i == index)
            pressedTo[i] = true;
          else
            pressedTo[i] = false;
        }
        LanguageDrawer.translateTo = languageData[index][2];
        LanguageDrawer.langChange(LanguageDrawer.translateTo);
      });
    }

    List<Widget> getFromDrawer() {
      List<Widget> listElement = new List(languageData.length);

      for (int i = 0; i < languageData.length; i++) {
        listElement[i] = FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(
            languageData[i][0],
            style: TextStyle(
                fontSize: 18.0,
                color: pressedFrom[i] ? Colors.black : Colors.white),
          ),
          color: pressedFrom[i] ? input : blue1,
          onPressed: () {
            setState(() {
              print('${languageData[i][0]} pressed (from)');
              changeFromActiveLanguageState(i);
            });
          },
        );
      }
      return listElement;
    }

    List<Widget> getToDrawer() {
      List<Widget> listElement = new List(languageData.length);

      for (int i = 0; i < languageData.length; i++) {
        listElement[i] = FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Text(
            languageData[i][0],
            style: TextStyle(
                fontSize: 18.0,
                color: pressedTo[i] ? Colors.black : Colors.white),
          ),
          color: pressedTo[i] ? output : blue1,
          onPressed: () {
            setState(() {
              print('${languageData[i][0]} pressed (to)');
              changeToActiveLanguageState(i);
            });
          },
        );
      }
      return listElement;
    }

    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: blue1,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
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
                          padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 15),
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
  }
}
