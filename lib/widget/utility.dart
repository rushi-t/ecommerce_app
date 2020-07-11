
import 'package:flutter/material.dart';

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