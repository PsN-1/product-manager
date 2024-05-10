import 'package:flutter/material.dart';

class CustomAlert {
  static void showOkCancelAlert(
    BuildContext context, {
    required String title,
    String? message,
    required void Function() okPressed,
  }) {
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
      content: (message != null) ? Text(message) : null,
      actions: [cancelButton, okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showOkAlert(
    BuildContext context, {
    required String title,
    String? message,
    required Function onOkPressed,
  }) {
    Widget okButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
          onOkPressed();
        },
        child: const Text('Ok'));

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: (message != null) ? Text(message) : null,
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
