import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

Widget getHomeAppBar(){
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