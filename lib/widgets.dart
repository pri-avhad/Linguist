import 'package:flutter/material.dart';

Widget converse(
    {Function onPressed, String text, Color color, String language}) {
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
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: color,
                      fontSize: 30,
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
                    radius: 20,
                    iconSize: 25,
                    bgColor: color),
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
