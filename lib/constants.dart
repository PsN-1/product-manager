import 'package:flutter/material.dart';

const kBackgroundColor = Color.fromRGBO(242, 242, 247, 1);
// const kPrimaryColor = Color.fromRGBO(255, 45, 85, 1);
const kPrimaryColor = Colors.blue;
const kTextStyle = TextStyle(fontSize: 22, color: Colors.black);
const kHistoryStyle = TextStyle(fontSize: 18, color: Colors.black);
const kLabelStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black54);

const kDeleteButtonStyle = ButtonStyle(
  backgroundColor: MaterialStatePropertyAll(Colors.red),
  foregroundColor: MaterialStatePropertyAll(Colors.white),
);

const kTextFieldInputDecoration = InputDecoration(
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
