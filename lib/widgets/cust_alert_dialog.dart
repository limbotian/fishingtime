import 'package:flutter/material.dart';

enum Action { Ok, Cancel }

Future openAlertDialog(context, text) async {
  final action = await showDialog(
    context: context,
    barrierDismissible: false, //// user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('提示'),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text('取消'),
            onPressed: () {
              Navigator.pop(context, Action.Cancel);
            },
          ),
          FlatButton(
            child: Text('确认'),
            onPressed: () {
              Navigator.pop(context, Action.Ok);
            },
          ),
        ],
      );
    },
  );
  return action;
}
