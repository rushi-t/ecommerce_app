import 'package:ecommerce_app/screens/admin/product_screen.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/control_validation.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ForgetPassword extends StatefulWidget {
  final String pageTitle;

  ForgetPassword({Key key, this.pageTitle}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final AuthService _auth = AuthService();
  final ValidationService _validationService = ValidationService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          title: Text('Forget Password', style: contrastText),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
//                Navigator.of(context).pushReplacementNamed('/signin');
                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, child: Auth(Home())));
              },
              child: Text('Sign In', style: contrastText),
            )
          ],
        ),
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Reset Password!', style: h3),
                          Text('An email will be sent allowing you to reset your password', style: taglineText),
//                        TextInput('Username'),
//                        TextInput('Full Name'),

                          EmailInput('Email',
                              onChanged: (val) {
                            setState(() => email = val);
                          }),

                        ],
                      ),
                      Positioned(
                        bottom: 15,
                        right: -15,
                        child: FlatButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.sendPasswordResetEmail(email);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Please supply a valid email';
                                });
                              } else {
                                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: Home()));
                              }
                            }
                          },
                          color: primaryColor,
                          padding: EdgeInsets.all(13),
                          shape: CircleBorder(),
                          child: Icon(Icons.arrow_forward, color: white),
                        ),
                      )
                    ],
                  ),
                  height: 192,
                  width: double.infinity,
//                decoration: authPlateDecoration,
                ),
              ],
            ),
          ),
        ));
  }
}
