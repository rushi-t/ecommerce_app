import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/services/storage.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/loading.dart';
import 'package:ecommerce_app/widget/ImagePickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/services.dart';
import 'package:image_picker_web/src/Models/Types.dart';

import 'package:chips_choice/chips_choice.dart';
import 'package:dio/dio.dart';

class ProductForm extends StatefulWidget {
  Product product = Product();

  ProductForm({Product product}) : product = product ?? new Product();

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  MediaInfo _imageData;
  List<String> tags = [];

  Future<Uri> uploadImageFile(var image, {String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref();
    fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(image).future;

    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    return imageUri;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('My Orders'),
          backgroundColor: primaryColor,
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: StreamBuilder<List<Category>>(
              stream: CategoryService().categoriesStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Category> categoryList = snapshot.data;
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          (widget.product.uid == null ? 'Add' : 'Update') + ' Product',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        SizedBox(height: 20.0),
                        ImagePickerWidget(
                            passedImgUrl: widget.product.imgUrl,
                            onImageChanged: (imageData) {
                              setState(() {
                                _imageData = imageData;
                              });
                            }),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  final ingredientFormKey = GlobalKey<FormState>();
                                  String ingredient;
                                  double priceOffset;
                                  return AlertDialog(
                                    title: Text('Add Ingredient'),
                                    content: Form(
                                      key: ingredientFormKey,
                                      child: Container(
                                        height: 150,
                                        child: Column(children: <Widget>[
                                          TextFormField(
                                            decoration: textInputDecoration(labelText: "Ingredient Name"),
                                            validator: (val) => val.isEmpty ? 'Please enter Ingredient Name' : null,
                                            onChanged: (val) => setState(() => ingredient = val),
                                          ),
                                          SizedBox(height: 20.0),
                                          TextFormField(
//                                            keyboardType: TextInputType.number,
                                            decoration: textInputDecoration(labelText: "Price Offset"),
                                            validator: (val) => val.isEmpty ? 'Please enter Price Offset' : null,
                                            inputFormatters: [WhitelistingTextInputFormatter(RegExp(r'^-?(\d+)?\.?\d{0,2}'))],
                                            onChanged: (val) => setState(() => priceOffset = double.tryParse(val)),
                                          )
                                        ]),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            if (ingredientFormKey.currentState.validate()) {
                                              if (widget.product.attributes == null || !widget.product.attributes.containsKey("ingredients")) {
                                                widget.product.addAttribute("ingredients", false);
                                              }
                                              setState(() {
                                                widget.product.attributes["ingredients"].addChild(ingredient, priceOffset, false);
                                                print(widget.product.toJson());
                                                Navigator.of(context).pop();
                                              });
                                            }
                                          },
                                          child: Text('Add'))
                                    ],
                                  );
                                }).then((value) => print('Result: ' + value.toString()));
                          },
                          child: Text('Add Ingredient'),
                        ),
                        SizedBox(height: 20.0),
                        () {
                          if (widget.product.attributes != null && widget.product.attributes.containsKey("ingredients")) {
                            print(widget.product.attributes["ingredients"].children.keys.toString());
                          }

                          return ChipsChoice<String>.multiple(
                            value: tags,
                            options: ChipsChoiceOption.listFrom<String, String>(
                              source: (widget.product.attributes != null && widget.product.attributes.containsKey("ingredients"))
                                  ? widget.product.attributes["ingredients"].children.keys.toList()
                                  : [],
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            onChanged: (val) => setState(() => print(val)),
                            itemConfig: ChipsChoiceItemConfig(
                              selectedColor: Colors.indigo,
                              selectedBrightness: Brightness.dark,
                              unselectedColor: Colors.indigo,
                              unselectedBorderOpacity: .3,
                            ),
                            itemBuilder: (item, selected, select) {
                              return FittedBox(
                                child: Row(children: <Widget>[
                                  Text(item.value),
                                  IconButton(
                                      icon: new Icon(Icons.clear),
                                      onPressed: () async {
                                        print("removing- " + item.toString());
                                        setState(() {
                                          widget.product.attributes["ingredients"].children.remove(item.value);
                                        });
                                      }),
                                ]),
                              );
                            },
                            isWrapped: true,
                          );
                        }(),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: widget.product.name,
                          decoration: textInputDecoration(labelText: "Product Name"),
                          validator: (val) => val.isEmpty ? 'Please enter Product Name' : null,
                          onChanged: (val) => setState(() => widget.product.name = val),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: widget.product.price != null ? widget.product.price.toString() : "",
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration(labelText: "Product Price"),
                          validator: (val) => val.isEmpty ? 'Please enter Product Price' : null,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          onChanged: (val) => setState(() => widget.product.price = double.tryParse(val)),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: widget.product.description,
                          decoration: textInputDecoration(labelText: "Product Description"),
                          validator: (val) => val.isEmpty ? 'Please enter Product Description' : null,
                          onChanged: (val) => setState(() => widget.product.description = val),
                        ),
                        SizedBox(height: 10.0),
                        DropdownButtonFormField(
                          value: widget.product.categoryUid,
                          decoration: textInputDecoration(labelText: "Product Category"),
                          items: categoryList.map((category) {
                            return DropdownMenuItem(
                              value: category.uid,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (String categoryUid) {
                            setState(() {
                              widget.product.categoryUid = categoryUid;
                            });
                          },
                        ),
                        SizedBox(height: 10.0),
                        RaisedButton(
                            color: Colors.pink[400],
                            child: Text(
                              widget.product.uid == null ? 'Add' : 'Update',
                              style: TextStyle(color: Colors.white70),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  if (_imageData != null && widget.product.imgUrl != null && widget.product.imgUrl != "") {
                                    try {
                                      await StorageService().deleteImage(_imageData, "product", widget.product.uid);
                                      widget.product.imgUrl = null;
                                      print("Old image deleted");
                                    } on Exception catch (e) {
                                      print("Error while deleting old image" + e.toString());
                                    }
                                  }

                                  if (_imageData != null) {
                                    try {
                                      Uri uri = await StorageService().createImage(_imageData, "product", widget.product.uid);
                                      if (uri != null) {
                                        widget.product.imgUrl = uri.toString();
                                        print("new image added");
                                      }
                                    } on Exception catch (e) {
                                      print("Error while creating new image" + e.toString());
                                    }
                                  }

                                  await ProductService().updateProduct(widget.product);
                                  Navigator.pop(context);
                                } on Exception catch (e) {
                                  print("Error while uploading image" + e.toString());
                                }
                              }
                            }),
                      ],
                    ),
                  );
                } else {
                  return Loading();
                }
              }),
        ));
  }
}
