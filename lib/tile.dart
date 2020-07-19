import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';

import 'constants.dart';


class tile extends StatefulWidget {
  final String language;
  final String languageCode;
  tile({@required this.language, @required this.languageCode});

  @override
  _tileState createState() => new _tileState();
}

class _tileState extends State<tile> {


  final ModelManager modelManager = FirebaseLanguage.instance.modelManager();
  int _state = 1;
  bool downloadState = false;
  String currentStatus;

  Future<void> checkStatus(String langCode) async {
    List<String> downloadedList = await modelManager.viewModels();
    print(downloadedList);
    for (int i = 0; i < downloadedList.length; i++) {
      if (downloadedList[i] == langCode) {
        downloadState = true;
        break;
      }
    }
  }

  Widget trail_icon() {
    if (_state == 0) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(input),
      );
    } else if (_state == 1) {
      return Icon(
        Icons.arrow_downward,
        color: input,
      );
    } else if (_state == 2) {
      return Icon(
        Icons.delete,
        color: Colors.black,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus(widget.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          widget.language,
          style: downloadState ? offline : online,
        ),
        //trailing: Icon(Icons.arrow_downward),
        onTap: () async {
          if (_state == 1 || _state == 2) {
            setState(() {
              _state = 0;
            });
          }
          if (downloadState == false) {
            currentStatus =
            await modelManager.downloadModel(widget.languageCode);
            print('downloading ... $currentStatus');
            setState(() {
              _state = 2;
              downloadState = !downloadState;
            });
          } else {
            currentStatus = await modelManager.deleteModel(widget.languageCode);
            print('deleting ... $currentStatus');
            setState(() {
              _state = 1;
              downloadState = !downloadState;
            });
          }
        },
        trailing: trail_icon());
  }
}
