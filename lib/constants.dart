import 'package:flutter/material.dart';

class K {
  const K();

  static const backgroundColor = Color.fromRGBO(242, 242, 247, 1);
  static const cardColor = Color.fromRGBO(226, 232, 240, 1);
  static const primaryColor = Colors.blue;
  static const textStyle = TextStyle(fontSize: 22, color: Colors.black);
  static const historyStyle = TextStyle(fontSize: 18, color: Colors.black);
  static const labelStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.black54,
  );

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

class AppK {
  const AppK();

  static const url = 'https://iqghfjlsyvdpvnnondyp.supabase.co';
  static const anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxZ2hmamxzeXZkcHZubm9uZHlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTYyNjMwODUsImV4cCI6MjAxMTgzOTA4NX0.PLRjPi5rwZujoPKQyopwr52RFiqpxhKt5Vvz8vGdhts';

  static const appVersion = "0.82";
}
