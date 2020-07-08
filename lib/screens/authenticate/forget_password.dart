import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:ecommerce_app/screens/authenticate/authenticate.dart';

class ForgetPassword extends StatefulWidget {

  final Function toggleView;
  ForgetPassword({ this.toggleView });

  @override
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPassword> {

  final AuthService _auth = AuthService();
//  final FeedbackService _feedbackService = FeedbackService(uid: Uuid().v1().toString());

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
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Forget Password'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[

              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration().copyWith(hintText: 'Email'),
                validator: (val) => validateEmail(val),
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),

              SizedBox(height: 20.0),
              RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),

                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      await _auth.sendPasswordResetEmail(email);
                     print( "A password reset link has been sent to $email");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Authenticate()),
                      );
                    }
                  }
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  String validateMobile(String value) {
      String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
      RegExp regExp = new RegExp(patttern);
      if (value.length == 0) {
        return 'Please enter mobile number';
      }
      else if (value.length != 10) {
        return 'Please enter 10 digit mobile number';
      }
      else if (!regExp.hasMatch(value)) {
        return 'Please enter valid mobile number';
      }
      else
      return null;
    }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}