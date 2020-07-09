import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/services/storage.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/loading.dart';
import 'package:ecommerce_app/widget/ImagePickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/services.dart';
import 'package:image_picker_web/src/Models/Types.dart';

class ProductForm extends StatefulWidget {
  Product product = Product();

  ProductForm({Product product}) : product = product ?? new Product();

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  MediaInfo _imageData;

  Future<Uri> uploadImageFile(var image, {String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref();
    fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(image).future;

    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    return imageUri;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Category>>(
        stream: CategoryService().categoriesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> categoryList = snapshot.data;
            print(categoryList);
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
                  TextFormField(
                    initialValue: widget.product.name,
                    decoration: textInputDecoration(labelText: "Product Name"),
                    validator: (val) => val.isEmpty ? 'Please enter Product Name' : null,
                    onChanged: (val) => setState(() => widget.product.name = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: widget.product.price != null ? widget.product.price.toString(): "",
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
        });
  }
}
