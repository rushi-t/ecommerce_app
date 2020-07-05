import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/storage.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/widget/ImagePickerWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/src/Models/Types.dart';

class CategoryForm extends StatefulWidget {
  Category category = Category();

  CategoryForm({Category category}) : category = category ?? new Category();

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  MediaInfo _imageData;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Add/Update Category',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 10.0),
          ImagePickerWidget(
              passedImgUrl: widget.category.imgUrl,
              onImageChanged: (imageData) {
                setState(() {
                  _imageData = imageData;
                });
              }),
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
                    if (widget.category.imgUrl != null && widget.category.imgUrl != "") {
                      try {
                        await StorageService().deleteImage(_imageData, "category", widget.category.uid);
                        widget.category.imgUrl = null;
                        print("Old image deleted");
                      } on Exception catch (e) {
                        print("Error while deleting old image" + e.toString());
                      }
                    }

                    if (_imageData != null) {
                      try {
                        Uri uri = await StorageService().createImage(_imageData, "category", widget.category.uid);
                        if (uri != null) {
                          widget.category.imgUrl = uri.toString();
                          print("new image added");
                        }
                      } on Exception catch (e) {
                        print("Error while creating new image" + e.toString());
                      }
                    }

                    await CategoryService().updateCategory(widget.category);
                    Navigator.pop(context);
                  } on Exception catch (e) {
                    print("Error while uploading image" + e.toString());
                  }
                }
              }),
        ],
      ),
    );
  }
}
