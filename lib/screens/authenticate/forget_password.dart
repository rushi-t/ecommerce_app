import 'package:ecommerce_app/screens/admin/product_screen.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ForgetPassword extends StatefulWidget {
  Widget redirectWidget;

 ForgetPassword(this.redirectWidget);
  //ForgetPassword();

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
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
          backgroundColor: primaryColor,
          title: Container(),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
//                Navigator.of(context).pushReplacementNamed('/signin');
                Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, child: Auth(widget.redirectWidget)));
              },
              child: Text('Forget Password!', style: whiteText),
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
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Forget Password", style: h3),
                    ),

                    EmailInput('Email', onChanged: (val) {
                      setState(() => email = val);
                    }),
                    Text('An email will be sent allowing you to reset your password', style: taglineText),
//                    PasswordInput('Password', onChanged: (val) {
//                      setState(() => password = val);
//                    }),
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
                                showProgressWithMessage(context, "Reseting Password");
                                setState(() => loading = true);
                                try {
                                  dynamic result = await _auth.sendPasswordResetEmail(email);
                                  if (widget.redirectWidget != null)
                                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: widget.redirectWidget));
                                  else
                                    Navigator.pop(context);
                                } catch (e) {
                                  Navigator.pop(context);
                                  setState(() {
                                    loading = false;
                                    error = e;
                                  });
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
        )
    );
  }
}
