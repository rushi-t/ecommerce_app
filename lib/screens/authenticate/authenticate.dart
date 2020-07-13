import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/authenticate/sign_up.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
//              Image.asset('images/welcome.png', width: 190, height: 190),
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 0),
                child: Text('eMarket!', style: logoStyle),
              ),
              Container(
                width: 200,
                margin: EdgeInsets.only(bottom: 0),
                child: FlatBtn('Sign In', (){
                  Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rotate, duration: Duration(seconds: 1),  child: Auth(Home())));
                }),
              ),
              Container(
                width: 200,
                padding: EdgeInsets.all(0),
                child: OutlineBtn('Sign Up', (){
                  Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rotate, duration: Duration(seconds: 1),  child: SignUp(Home())));
                  // Navigator.of(context).pushReplacementNamed('/signup');
                }),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: <Widget>[
                    Text('Langauage:', style: TextStyle(color: darkText)),
                    Container(
                      margin: EdgeInsets.only(left: 6),
                      child: Text('English ›', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              )
            ],
          )),
      backgroundColor: bgColor,
    );
  }
}
