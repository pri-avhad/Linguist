import 'package:flutter/material.dart';

Widget converse(
    {double size1,
    double size2,
    double radius,
    double icon,
    Function onPressed,
    String text,
    Color color,
    String language}) {
  return Container(
    width: double.infinity,
    child: Material(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                language,
                style: TextStyle(
                  color: color,
                  fontSize: size1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: color,
                      fontSize: size2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: iconButton(
                    icon: Icons.mic,
                    onPressed: onPressed,
                    radius: radius,
                    iconSize: icon,
                    bgColor: color),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget result(
    {Function onPressedSpeak,
    Color color,
    String language,
    String title,
    double titleSize,
    Widget output}) {
  return Container(
    width: double.infinity,
    child: Material(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Colors.white,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: output,
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      language,
                      style: TextStyle(
                        color: color,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: color,
                      size: titleSize,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                        icon: Icon(
                          Icons.volume_up,
                          color: color,
                          size: titleSize,
                        ),
                        onPressed: onPressedSpeak,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget iconButton(
    {IconData icon,
    Function onPressed,
    double radius,
    double iconSize,
    Color bgColor}) {
  return Material(
    shape: CircleBorder(),
    elevation: 5,
    child: CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Center(
        child: IconButton(
          splashColor: Colors.white,
          iconSize: iconSize,
          color: Colors.white,
          icon: Icon(icon),
          onPressed: onPressed,
        ),
      ),
    ),
  );
}
