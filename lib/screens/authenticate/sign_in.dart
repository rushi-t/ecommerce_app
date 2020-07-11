import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/sign_up.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/screens/user/product_screen.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  Widget redirectWidget;

  SignIn(this.redirectWidget);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
          title: Text('Sign In', style: TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 15)),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
//                Navigator.of(context).pushReplacementNamed('/signup');
                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: SignUp(widget.redirectWidget)));
              },
              child: Text('Sign Up', style: contrastText),
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
                          Text('Welcome Back!', style: h3),
                          Text('Hello, let\'s authenticate', style: taglineText),
                          EmailInput('Email', onChanged: (val) {
                            setState(() => email = val);
                          }),
                          PasswordInput('Password', onChanged: (val) {
                            setState(() => password = val);
                          }),
                          FlatButton(
                            onPressed: () {},
                            child: Text('Forgot Password?', style: contrastTextBold),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 15,
                        right: -15,
                        child: FlatButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              print("logging in");
                              setState(() => loading = true);
                              User user = await _auth.signInWithEmailAndPassword(email, password);
                              if (user == null) {
                                print('Could not sign in with those credentials');
                                setState(() {
                                  loading = false;
                                  error = 'Could not sign in with those credentials';
                                });
                              } else {
                                if (widget.redirectWidget != null)
                                  Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: widget.redirectWidget));
                                else
                                  Navigator.pop(context);
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
//                  decoration: authPlateDecoration,
                ),
              ],
            ),
          ),
        ));
  }
}
