import 'package:flutter/material.dart';

InputDecoration textInputDecoration({String labelText=""})
{
  return InputDecoration(
    labelText: labelText,
    fillColor: Colors.black12,
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink, width: 2.0),
    ),
  );
}
//const textInputDecoration() = InputDecoration(
//  fillColor: Colors.black12,
//  filled: true,
//  contentPadding: EdgeInsets.all(12.0),
//  enabledBorder: OutlineInputBorder(
//    borderSide: BorderSide(color: Colors.white, width: 2.0),
//  ),
//  focusedBorder: OutlineInputBorder(
//    borderSide: BorderSide(color: Colors.pink, width: 2.0),
//  ),
//);