import 'package:flutter/material.dart';

class DialogMessage extends StatelessWidget {
  final String title;
  final String content;



  DialogMessage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () => Navigator.pop(context), child: Text('OK'))
      ],
    );
  }
}

showDialogMessage(context, title, content) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogMessage(title: title, content: content);
      });
}
