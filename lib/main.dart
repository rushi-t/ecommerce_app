import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/admin/category_screen.dart' as AdminScreen;
import 'package:ecommerce_app/screens/admin/product_screen.dart' as AdminScreen;
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/cart_screen.dart';
import 'package:ecommerce_app/screens/user/product_detail.dart';
import 'package:ecommerce_app/screens/user/product_list.dart';
import 'package:ecommerce_app/screens/user/product_screen.dart' as UserScreen;
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/screens/user/contact_us.dart';
import 'package:ecommerce_app/screens/admin/user_profile_screen.dart';
import 'package:ecommerce_app/screens/user/user_profile.dart' as UserProfileScreen;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              accentColor: primaryColor
          ),
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            Localization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => Home(),
            '/home': (context) => Home(),
            '/auth': (context) => Auth(Home()),
            '/admin/category': (context) => AdminScreen.CategoryScreen(),
            '/admin/product': (context) => AdminScreen.ProductScreen(),
            '/admin/userProfile': (context) => UserProfileAdmin(),
            '/user/product': (context) => UserScreen.ProductScreen(),
            '/user/product-detail': (context) => ProductDetail(),
            '/user/cart': (context) => CartScreen(),
            '/user/contactUs': (context) => ContactUs(),
            '/user/userProfile': (context) => UserProfileScreen.UserProfile(),
            '/scratch': (context) => ProductList(),
          }),
    );
  }
}
