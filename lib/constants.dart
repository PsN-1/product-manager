import 'package:flutter/material.dart';

class K {
  const K();

  static const appVersion = "0.53";

  static const backgroundColor = Color.fromRGBO(242, 242, 247, 1);
  static const cardColor = Color.fromRGBO(226, 232, 240, 1);
  static const primaryColor = Colors.blue;
  static const textStyle = TextStyle(fontSize: 22, color: Colors.black);
  static const historyStyle = TextStyle(fontSize: 18, color: Colors.black);
  static const labelStyle = TextStyle(
      fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black54);

  static const deleteButtonStyle = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.red),
    foregroundColor: MaterialStatePropertyAll(Colors.white),
  );

  static const saveButtonStyle = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(primaryColor),
    foregroundColor: MaterialStatePropertyAll(Colors.white),
  );
  static const textFieldInputDecoration = InputDecoration(
    fillColor: Colors.white,
    hintText: 'Palavra-Chave...',
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    // border: OutlineInputBorder(
    //   borderRadius: BorderRadius.all(
    //     Radius.circular(10),
    //   ),
    //   borderSide: BorderSide.none,
    // ),
  );
}
