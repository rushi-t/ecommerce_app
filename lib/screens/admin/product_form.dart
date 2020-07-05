import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class ProductForm extends StatefulWidget {
  Product product = Product();

  ProductForm({Product product}) : product = product ?? new Product();

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  var _file;

  Future<Uri> uploadImageFile(var image, {String imageName}) async {
    fb.StorageReference storageRef = fb.storage().ref();
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageRef.put(image).future;

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
                  TextFormField(
                    initialValue: widget.product.name,
                    decoration: textInputDecoration(labelText: "Product Name"),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter Product Name' : null,
                    onChanged: (val) =>
                        setState(() => widget.product.name = val),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: widget.product.description,
                    decoration:
                        textInputDecoration(labelText: "Product Description"),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter Product Description' : null,
                    onChanged: (val) =>
                        setState(() => widget.product.description = val),
                  ),
                  SizedBox(height: 10.0),
                  DropdownButtonFormField(
                    value: widget.product.categoryUid,
                    decoration:
                        textInputDecoration(labelText: "Product Category"),
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
//                      uploadImageFile(_file, imageName: "test");
                          if (widget.product.uid == '')
                            await ProductService()
                                .createProduct(widget.product);
                          else
                            await ProductService()
                                .updateProduct(widget.product);
                          Navigator.pop(context);
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
