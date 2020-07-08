import 'package:ecommerce_app/screens/admin/product_screen.dart';
import 'package:ecommerce_app/screens/authenticate/sign_in.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SignUp extends StatefulWidget {
  final String pageTitle;

  SignUp({Key key, this.pageTitle}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
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
          title: Text('Sign Up', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 15)),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
//                Navigator.of(context).pushReplacementNamed('/signin');
                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, child: SignIn()));
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
                          Text('Welcome to eCommerce!', style: h3),
                          Text('Let\'s get started', style: taglineText),
//                        TextInput('Username'),
//                        TextInput('Full Name'),
                          EmailInput('Email', onChanged: (val) {
                            setState(() => email = val);
                          }),
                          PasswordInput('Password', onChanged: (val) {
                            setState(() => password = val);
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
                              dynamic result = await _auth.registerWithEmailAndPassword(email, password);
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
                  height: 250,
                  width: double.infinity,
//                decoration: authPlateDecoration,
                ),
              ],
            ),
          ),
        ));
  }
}
