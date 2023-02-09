import 'package:flutter/material.dart';

class CustomSnackBar {
  static void showSuccessMessage(
      BuildContext context, String text, void Function() onPressed) {
    showSnackBar(context, text, Colors.white, Colors.green, onPressed);
  }

  static void showErrorMessage(
      BuildContext context, String text, void Function() onPressed) {
    showSnackBar(context, text, Colors.white, Colors.red, onPressed);
  }

  static void showSnackBar(BuildContext context, String text, Color textColor,
      Color backgroundColor, void Function() onPressed) {
    final snackBar = SnackBar(
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.white,
        onPressed: onPressed,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
