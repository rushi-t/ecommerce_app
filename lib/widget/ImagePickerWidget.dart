import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:image_picker_web/src/Models/Types.dart';

typedef ImageDataCallBack = Function(MediaInfo imageData);

class ImagePickerWidget extends StatefulWidget {
  final String passedImgUrl;
  final ImageDataCallBack onImageChanged;
  ImagePickerWidget({this.passedImgUrl, this.onImageChanged});

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String imgUrl;
  MediaInfo imageData;

  @override
  initState() {
    imgUrl = widget.passedImgUrl;
    super.initState();
  }

  Future getImageFromPicker() async {
    var imageData = await ImagePickerWeb.getImageInfo;
    if (imageData != null) {
      setState(() {
//        print(imageData.data);
        this.imageData = imageData;
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
              imageData.data,
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