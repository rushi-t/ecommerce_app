import 'package:ecommerce_app/models/feedback.dart' as fb;
import 'package:ecommerce_app/screens/admin/feedback_screen.dart';
import 'package:ecommerce_app/screens/admin/product_screen.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/feedback.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';


class ContactUs extends StatefulWidget {

  ContactUs();

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String phone = '';
  String name = '';
  String message = '';


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
                //Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, child: Auth(widget.redirectWidget)));
              },
              child: Text('Sign In', style: whiteText),
            )
          ],
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).orientation == Orientation.landscape ? 420 : null,
            height: 530,
            decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey[300])),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("Contact Us", style: h3),
                    ),
                    TextInput('Name','', onChanged: (val) {
                      setState(() => name = val);
                    }),
                    TextPhoneInput('Phone','', onChanged: (val) {
                      setState(() => phone = val);
                    }),
                    EmailInput('Email', onChanged: (val) {
                      setState(() => email = val);
                    }),
                    TextAddressInput('Feedback','', onChanged: (val) {
                      setState(() => message = val);
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
                                showProgressWithMessage(context, "Saving Feedback");
                                setState(() => loading = true);
                                //create unique Id
                                try {
                                  fb.Feedback feedback = fb.Feedback();
                                 // fb.Feedback feedback ;
                                  feedback.message=message;
                                  feedback.phone =phone;
                                  feedback.email =email;
                                  feedback.name=name;
                                  print(feedback.uid);
                                  await FeedbackService().updateFeedback(feedback);
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
