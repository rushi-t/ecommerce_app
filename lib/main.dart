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
import 'package:ecommerce_app/screens/user/contact_us.dart';
import 'package:ecommerce_app/screens/admin/feedback_screen.dart';
import 'package:ecommerce_app/screens/admin/user_profile_screen.dart';
import 'package:ecommerce_app/screens/user/user_profile.dart' as UserProfileScreen;
import 'package:ecommerce_app/screens/authenticate/forget_password.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          initialRoute: '/home',
          routes: {
            '/': (context) => Wrapper(),
            '/home': (context) => Home(),
            '/signin': (context) => SignIn(),
            '/signup': (context) => SignUp(),
            '/admin/category': (context) => AdminScreen.CategoryScreen(),
            '/admin/product': (context) => AdminScreen.ProductScreen(),
            '/admin/feedback': (context) => AdminFeedback(),
            '/admin/userProfile': (context) => UserProfileAdmin(),
            '/user/product': (context) => UserScreen.ProductScreen(),
            '/user/cart': (context) => CartScreen(),
            '/user/contactUs': (context) => ContactUs(),
            '/user/userProfile': (context) => UserProfileScreen.UserProfile(),
            '/user/forgetPassword': (context) => ForgetPassword(),
            '/scratch': (context) => Home(),

          }
      ),
    );
  }
}