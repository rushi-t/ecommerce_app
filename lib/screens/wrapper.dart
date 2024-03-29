import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_app/screens/user/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
//    print("Wrapper user= " + (user != null ? user.uid.toString(): "null"));
    // return either the Home or Authenticate widget
    if (user == null){
//      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: Authenticate()));
      return Authenticate();
    } else {
//      return Home();
//      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: Authenticate()));
      return Home();
    }
    
  }
}