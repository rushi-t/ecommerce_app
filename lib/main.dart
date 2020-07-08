import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/admin/category_screen.dart' as AdminScreen;
import 'package:ecommerce_app/screens/admin/product_screen.dart' as AdminScreen;
import 'package:ecommerce_app/screens/authenticate/sign_up.dart';
import 'package:ecommerce_app/screens/authenticate/sign_in.dart';
import 'package:ecommerce_app/screens/user/cart_screen.dart';
import 'package:ecommerce_app/screens/user/product_screen.dart' as UserScreen;
import 'package:ecommerce_app/screens/user/product_tab.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/screens/wrapper.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          initialRoute: '/scratch',
          routes: {
            '/': (context) => Wrapper(),
            '/home': (context) => Home(),
            '/signin': (context) => SignIn(),
            '/signup': (context) => SignUp(),
            '/admin/category': (context) => AdminScreen.CategoryScreen(),
            '/admin/product': (context) => AdminScreen.ProductScreen(),
            '/user/product': (context) => UserScreen.ProductScreen(),
            '/user/cart': (context) => CartScreen(),
            '/scratch': (context) => Home(),

          }
      ),
    );
  }
}