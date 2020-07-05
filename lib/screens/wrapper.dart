import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/authenticate.dart';
import 'package:ecommerce_app/screens/home/home.dart';
import 'package:ecommerce_app/screens/user/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/screens/user/product_screen.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
//    print(user);
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
//      return Home();
      return ProductScreen();
    }
    
  }
}