import 'package:flutter/material.dart';
import 'package:firebase_mlkit_language/firebase_mlkit_language.dart';
import 'constants.dart';

class tile extends StatefulWidget {
  final String language;
  final String languageCode;
  tile({
    @required this.language,
    @required this.languageCode,
  });

  @override
  _tileState createState() => new _tileState();
}

class _tileState extends State<tile> {
  final ModelManager modelManager = FirebaseLanguage.instance.modelManager();
  int _state = 1;
  bool downloadState = false;
  String currentStatus;
  Widget trail_icon() {
    if (_state == 0) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.028,
        width: MediaQuery.of(context).size.height * 0.028,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(input),
        ),
      );
    } else if (_state == 1) {
      return SizedBox();
    } else if (_state == 2) {
      return Icon(
        Icons.delete,
        color: instructions,
        size: MediaQuery.of(context).size.height * 0.028,
      );
    }
  }

  Widget lead_icon() {
    if (_state == 2) {
      return Icon(
        Icons.check,
        color: instructions,
        size: MediaQuery.of(context).size.height * 0.028,
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ListTile(
      title: Text(widget.language,
          style: downloadState
              ? TextStyle(
                  fontSize: height * 0.024,
                  color: instructions,
                )
              : TextStyle(fontSize: height * 0.024, color: blue1)),
      onTap: () async {
        if (_state == 1 || _state == 2) {
          setState(() {
            _state = 0;
          });
        }
        if (downloadState == false) {
          currentStatus = await modelManager.downloadModel(widget.languageCode);
          setState(() {
            _state = 2;
            downloadState = !downloadState;
          });
        } else {
          currentStatus = await modelManager.deleteModel(widget.languageCode);
          setState(() {
            _state = 1;
            downloadState = !downloadState;
          });
        }
      },
      trailing: trail_icon(),
      leading: lead_icon(),
    );
  }
}
