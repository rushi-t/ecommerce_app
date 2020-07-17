import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

Widget getHomeAppBar() {
  return SliverAppBar(
    pinned: false,
    floating: false,
    snap: false,
    leading: new Container(),
    backgroundColor: primaryColor,
    centerTitle: true,
    title: Text('eMarket', style: logoWhiteStyle, textAlign: TextAlign.center),
  );
}

AlertDialog showProgressWithMessage(BuildContext context, String message) {
  AlertDialog alertDialog = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 5), child: Text(message)),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
  return alertDialog;
}

Widget showLoadingWidget(){
  return Center(child: CircularProgressIndicator());
}
