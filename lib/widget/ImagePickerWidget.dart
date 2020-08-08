import 'dart:typed_data';

import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ecommerce_app/widget/utility.dart' as utility;
import 'package:file_picker_cross/file_picker_cross.dart';


typedef ImageDataCallBack = Function(Uint8List imageData);

class ImagePickerWidget extends StatefulWidget {
  final String passedImgUrl;
  final ImageDataCallBack onImageChanged;
  ImagePickerWidget({this.passedImgUrl, this.onImageChanged});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String imgUrl;
  Uint8List imageData;

  @override
  initState() {
    imgUrl = widget.passedImgUrl;
    super.initState();
  }

  Future getImageFromPicker() async {
    // Old picker
//    var imageData = await ImagePickerWeb.getImageInfo;
//    if (imageData != null) {
//      setState(() {
////        print(imageData.data);
//        this.imageData = imageData.data;
//        widget.onImageChanged(this.imageData);
//      });
//    }

    FilePickerCross filePickerCross = await FilePickerCross.pick();
    if (filePickerCross != null) {
      setState(() {
//        print(imageData.data);
        this.imageData = filePickerCross.toUint8List();
        widget.onImageChanged(this.imageData);
      });
    }
  }

  Widget showImage() {
    if (imgUrl != null && imgUrl != "") {
      return Container(
        child: Stack(
          children: <Widget>[
            Image.network(
              imgUrl,
              width: 100,
              height: 80,
            ),
            Positioned(
              right: -10.0,
              top: -10.0,
              child: IconButton(icon: new Icon(Icons.clear), onPressed: () async {
                setState(() {
                  imgUrl = null;
                  widget.onImageChanged(this.imageData);
                });
              }),
            )
          ],
        ),
      );
    }
    else if (imageData != null) {
      return Container(
        child: Stack(
          children: <Widget>[
            Image.memory(
              imageData,
              width: 100,
              height: 80,
            ),
            Positioned(
              right: -10.0,
              top: -10.0,
              child: IconButton(icon: new Icon(Icons.clear), onPressed: () async {
                setState(() {
                  imageData = null;
                  widget.onImageChanged(this.imageData);
                });
              }),
            )
          ],
        ),
      );
    }
    else {
      return RaisedButton(
        onPressed: () async {
          getImageFromPicker();
        },
        child: Text('Select image'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return showImage();
  }
}