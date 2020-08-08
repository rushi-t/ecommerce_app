import 'package:flutter/material.dart';
import 'dart:typed_data';

//class MediaInfo {
//  String fileName;
//  String base64;
//  String base64WithScheme;
//  Uint8List data;
//}

void showSnackBar(BuildContext context, String message, {String actionText, action}){
  Scaffold.of(context).showSnackBar(
    SnackBar(
    content: Text(message),
    action: actionText != null ? SnackBarAction(
      label: actionText,
      onPressed: action != null ? action : (){} ,
    ) : null,
  ));
}