import 'package:flutter/material.dart';

class CustomAlert {
  static void show(BuildContext context,
      {required String title,
      required String message,
      required void Function() okPressed}) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          okPressed();
        },
        child: const Text('Ok'));

    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancelar'));

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [cancelButton, okButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
