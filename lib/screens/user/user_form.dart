import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/user.dart' ;
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/services/user.dart';
import 'package:ecommerce_app/services/storage.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/loading.dart';
import 'package:ecommerce_app/widget/ImagePickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/services.dart';
import 'package:image_picker_web/src/Models/Types.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart' as tb;
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:page_transition/page_transition.dart';

class UserForm extends StatefulWidget {
  Product product = Product();

  UserForm() ;

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  MediaInfo _imageData;
  String userName;
  String userPhone;
  String userAddress;
  String error = '';
  bool loading = false;

  Future<Uri> uploadImageFile(var image, {String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref();
    fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(image).future;

    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    return imageUri;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
           User user = snapshot.data;
            print(user.uid );
           //widget.user.name ='Test';
           print(user.name );
           print(user.phone );
           print(user.email  );
           print(user.address);

//            return Form(
//              key: _formKey,
//              child: Column(
//                children: <Widget>[
//                  Text(
//                    "Profile Settings",
//                    style: TextStyle(
//                      color:Colors.black87,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 16,
//                    ),
//                    textAlign: TextAlign.left,
//                  ) ,
//
//                  SizedBox(height: 20.0),
//                  TextFormField(
//                    initialValue: user.name,
//                    decoration: textInputDecoration(labelText: "Name"),
//                    validator: (val) => val.isEmpty ? 'Please enter Name' : null,
//                    onChanged: (val) => setState(() => userName = val),
//                  ),
//                  SizedBox(height: 20.0),
//                  TextFormField(
//                    initialValue: user.phone != null ? user.phone.toString(): "",
//                    keyboardType: TextInputType.number,
//                    decoration: textInputDecoration(labelText: "Phone"),
//                    validator: (val) => val.isEmpty ? 'Please enter Phone' : null,
//                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
//                    onChanged: (val) => setState(() => userPhone = val),
//                  ),
////                  SizedBox(height: 20.0),
////                  TextFormField(
////                    initialValue: widget.product.description,
////                    decoration: textInputDecoration(labelText: "Email"),
////                    validator: (val) => val.isEmpty ? 'Please enter Email' : null,
////                    onChanged: (val) => setState(() => widget.product.description = val),
////                  ),
//                  SizedBox(height: 20.0),
//                  TextFormField(
//                    initialValue: user.address,
//                    decoration: textInputDecoration(labelText: "Shipping Address"),
//                    maxLines: 4,
//                    validator: (val) => val.isEmpty ? 'Please enter Shipping Address' : null,
//                    onChanged: (val) => setState(() => userAddress = val),
//                  ),
////
////                  SizedBox(height: 10.0),
////                  DropdownButtonFormField(
////                    value: widget.product.categoryUid,
////                    decoration: textInputDecoration(labelText: "Product Category"),
////                    items: categoryList.map((category) {
////                      return DropdownMenuItem(
////                        value: category.uid,
////                        child: Text(category.name),
////                      );
////                    }).toList(),
////                    onChanged: (String categoryUid) {
////                      setState(() {
////                        widget.product.categoryUid = categoryUid;
////                      });
////                    },
////                  ),
//                  SizedBox(height: 10.0),
//                  RaisedButton(
//                      color: Colors.pink[400],
//                      child: Text(
//                        'Update',
//                        style: TextStyle(color: Colors.white70),
//                      ),
//                      onPressed: () async {
//                        print(userName);
//                        print(userAddress);
//                        print(userPhone);
//                        if (_formKey.currentState.validate()) {
//                          try {
//
//                            user.phone = userPhone == null ?"" :userPhone;
//                            user.address = userAddress == null ?"" :userAddress;
//                            user.name = userName == null ?"" :userName;
//
//                            await UserService().updateUser(user);
//                            Navigator.pop(context);
//                          } on Exception catch (e) {
//                            print("Error while updating user profile " + e.toString());
//                          }
//                        }
//                      }),
//                ],
//              ),
//            );
//

          return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text("User Profile", style: h3),
                  ),
                  tb.TextInput('Name', user.name,onChanged: (val) {
                    setState(() => userName = val);
                  }),
                  tb.TextPhoneInput('Phone', user.phone,onChanged: (val) {
                    setState(() => userPhone = val);
                  }),
                  tb.TextAddressInput('Address',user.address ,onChanged: (val) {
                    setState(() => userAddress = val);
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
                              showProgressWithMessage(
                                  context, "User profile Settings");
                              setState(() => loading = true);
                              user.phone = userPhone == null ? "" : userPhone;
                              user.address =
                              userAddress == null ? "" : userAddress;
                              user.name = userName == null ? "" : userName;

                              await UserService().updateUser(user);
                              Navigator.pop(context);
                            }
                          },
                          color: primaryColor,
                          icon: Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
          } else {
            return Loading();
          }
        });
  }
}
