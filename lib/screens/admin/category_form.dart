import 'dart:convert';

import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/storage.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:image_picker_web/src/Models/Types.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:http/http.dart' as http;
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'dart:typed_data';

class CategoryForm extends StatefulWidget {
  Category category = Category();

  CategoryForm({Category category}) : category = category ?? new Category();

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  dynamic _imageData;

  Future getImage() async {
    var imageData = await ImagePickerWeb.getImageInfo;
    if (imageData != null) {
      setState(() {
//        print(imageData.data);
        _imageData = imageData;
      });
    }
  }

//  Future<Uri> uploadImage(String imageName) async {
//    final filePath = 'category/$imageName.png';
//    dynamic uploadTask = fb.storage().refFromURL('gs://ecommerce-app-bb2d6.appspot.com').child(filePath).put(_imageData.data, fb.UploadMetadata(contentType: 'image/jpg'));
//    dynamic snapshot = await uploadTask.future;
//    return snapshot.ref.getDownloadURL();
//  }

  Widget enableUpload() {
    return Container(
      child: Stack(
        children: <Widget>[ Image.memory(
                  _imageData.data,
                  width: 100,
                  height: 80,
                ),
          Positioned(
            right: -10.0,
            top: -10.0,
            child: IconButton(
                icon: new Icon(Icons.clear),
                onPressed: () async {
                  await StorageService().deleteImage(_imageData, "category", widget.category.uid);
                  widget.category.imgUrl = null;
                  await CategoryService().updateCategory(widget.category);
                  setState(() {
                    _imageData = null;
                  });
                }),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
//    if (widget.category.imgUrl != null && widget.category.imgUrl != "") {
//      networkImageToByte(widget.category.imgUrl).then((response) {
//        setState(() {
//          _imageData = new MediaInfo();
//          _imageData.data = response;
//        });
//      });
//    }

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Add/Update Category',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 10.0),
          _imageData == null
              ? RaisedButton(
                  onPressed: () async {
                    getImage();
                  },
                  child: Text('Select image'),
                )
              : enableUpload(),
          SizedBox(height: 10.0),
          TextFormField(
            initialValue: widget.category.name,
            decoration: textInputDecoration(),
            validator: (val) => val.isEmpty ? 'Please enter Category' : null,
            onChanged: (val) => setState(() => widget.category.name = val),
          ),
          SizedBox(height: 10.0),
          RaisedButton(
              color: Colors.pink[400],
              child: Text(
                'Update',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  try {
//                    if (_imageData != null) {
//                      if (widget.category.imgUrl == null || widget.category.imgUrl == "") {
//                        await StorageService().deleteImage(_imageData, "category", widget.category.uid);
//                        print("old image deleted");
//                      }
//                      Uri uri = await StorageService().createImage(_imageData, "category", widget.category.uid);
//                      if (uri != null) {
//                        widget.category.imgUrl = uri.toString();
//                        print("new image added");
//                      }
//                    }
                    await CategoryService().updateCategory(widget.category);
                    Navigator.pop(context);
                  } on Exception catch (e) {
                    print("Error while uploading image");
                  }
                }
              }),
        ],
      ),
    );
  }
}
