

import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:flutter/material.dart';

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
            print(context.toString());
//            Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute()),);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Auth(null)));
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            print(context.toString());
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}