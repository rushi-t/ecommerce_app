import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Scratch extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<Scratch> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
  final List<int> strengths = [100, 200, 300, 400, 500, 600, 700, 800, 900];

  // form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    User user = Provider.of<User>(context);

    return Scaffold(
      body: StreamBuilder<List<Product>>(
          stream: ProductService().productsStream,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              List<Product> productList = snapshot.data;
              print(productList);
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Update your brew settings.',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: productList.length.toString(),
                      decoration: textInputDecoration(),
                      validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                      onChanged: (val) => setState(() => _currentName = val),
                    ),
                    SizedBox(height: 10.0),
                  DropdownButtonFormField(

                    decoration: textInputDecoration(),
                    items: productList.map((product) {
                      return DropdownMenuItem(
                        value: product.uid,
                        child: Text(product.name),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val ),
                  ),
                  SizedBox(height: 10.0),

                  ],
                ),
              );
            } else {
              return Loading();
            }
          }
      ),
    );
  }
}