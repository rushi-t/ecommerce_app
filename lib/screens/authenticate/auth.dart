import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  final Widget redirectWidget;

  Auth(this.redirectWidget);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool signInSignUpToggle = true;
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: Container(),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                setState(() {
                  signInSignUpToggle = !signInSignUpToggle;
                });

//                Navigator.of(context).pushReplacementNamed('/signup');
//                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: SignUp(widget.redirectWidget)));
              },
              child: Text('Sign Up', style: whiteText),
            )
          ],
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).orientation == Orientation.landscape ? 420 : null,
            height: 300,
            decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey[300])),
            child: signInSignUpToggle ? Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Sign In", style: h3),
                    ),
                    EmailInput('Email', onChanged: (val) {
                      setState(() => email = val);
                    }),
                    PasswordInput('Password', onChanged: (val) {
                      setState(() => password = val);
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Text('Forgot Password?', style: contrastTextBold),
                        ),
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 20,
                          child: IconButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                showProgressWithMessage(context, "Signing In");
                                User user = await _auth.signInWithEmailAndPassword(email, password);
                                Navigator.pop(context);
                                if (user == null) {
                                  setState(() {
                                    error = 'Invalid email or password';
                                  });
                                } else {
                                  if (widget.redirectWidget != null)
                                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: widget.redirectWidget));
                                  else {
                                    Navigator.pop(context, true);
                                  }
                                }
                              }
                            },
                            color: primaryColor,
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                )) : Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Sign Up", style: h3),
                    ),
                    EmailInput('Email', onChanged: (val) {
                      setState(() => email = val);
                    }),
                    PasswordInput('Password', onChanged: (val) {
                      setState(() => password = val);
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: 20,
                          child: IconButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                showProgressWithMessage(context, "Registering");
                                dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                Navigator.pop(context);
                                if (result == null) {
                                  Navigator.pop(context);
                                  setState(() {
                                    error = 'This email is already in use by another account';
                                  });
                                } else {
                                  if (widget.redirectWidget != null)
                                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: widget.redirectWidget));
                                  else
                                    Navigator.pop(context, true);
                                }
                              }
                            },
                            color: primaryColor,
                            icon: Icon(Icons.arrow_forward, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ));
  }
}
