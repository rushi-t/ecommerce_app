import 'package:ecommerce_app/screens/admin/product_screen.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';
import 'package:ecommerce_app/services/feedback.dart';
import 'package:ecommerce_app/screens/user/home.dart';

class ContactUs extends StatefulWidget {
  final String pageTitle;

  ContactUs({Key key, this.pageTitle}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final AuthService _auth = AuthService();
  final FeedbackService _feedbackService = FeedbackService(uid: Uuid().v1().toString());

  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String name = '';
  String phone = '';
  String email = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          title: Text('Contact Us', style: contrastText),
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
                         // Text('Welcome to eCommerce!', style: h3),
                          //Text('Let\'s get started', style: taglineText),
//                        TextInput('Username'),
//                        TextInput('Full Name'),
                          TextInput('Name','',onTap:(()=>100) , onChanged: (val) {
                            setState(() => name = val);
                          }),
                          TextInput('Phone','', onChanged: (val) {
                            setState(() => phone = val);
                          }),
                          EmailInput('Email', onChanged: (val) {
                            setState(() => email = val);
                          }),
                          TextInput('Feedback','', onChanged: (val) {
                            setState(() => message = val);
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
                              await _feedbackService.addFeedbackData(name, phone, email, message);
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
                  height: 318,
                  width: double.infinity,
//                decoration: authPlateDecoration,
                ),
              ],
            ),
          ),
        ));
  }
}
