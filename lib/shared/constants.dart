import 'package:flutter/material.dart';

const double MAX_SCREEN_WIDTH = 1200;
const double searchBarHeight = 60;

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

double getScreenWidth(context){
 return MediaQuery.of(context).orientation == Orientation.landscape ? MAX_SCREEN_WIDTH : MediaQuery.of(context).size.width;
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