import 'package:flutter/material.dart';

const kTextStyle = TextStyle(fontSize: 22, color: Colors.black);
const kHistoryStyle = TextStyle(fontSize: 18, color: Colors.black);
const kLabelStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black54);

const kTextFieldInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  // icon: Icon(
  //   Icons.search,
  //   color: Colors.white,
  // ),
  hintText: 'Produto',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide.none,
  ),
);

