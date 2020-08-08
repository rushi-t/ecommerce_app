//import 'dart:async';
//import 'dart:io';
//
//import 'package:flutter/material.dart';
//
////Image Plugin
//import 'package:image_picker_web/image_picker_web.dart';
//import 'package:firebase/firebase.dart' as fb;
//import 'dart:html' as html;
//import 'package:path/path.dart' as Path;
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:mime_type/mime_type.dart';
//
//class FileUploadDemo extends StatefulWidget {
//  @override
//  _FileUploadDemoState createState() => new _FileUploadDemoState();
//}
//
//class _FileUploadDemoState extends State<FileUploadDemo> {
//  File _sampleImage;
//  dynamic _mediaData;
//  fb.UploadTask _uploadTask;
//
//  Future getImage() async {
//    var mediaData = await ImagePickerWeb.getImageInfo;
//    if (mediaData != null) {
//      setState(() {
//        _mediaData = mediaData;
//      });
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text('Image Upload'),
//        centerTitle: true,
//      ),
//      body: Column(
//        children: [
//          Container(
//            child: Center(
//              child: _mediaData == null ? Text('Select an image') : enableUpload(),
//            ),
//          ),
//          Spacer(),
//        ],
//      ),
//      floatingActionButton: new FloatingActionButton(
//        onPressed: getImage,
//        tooltip: 'Add Image',
//        child: new Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//
//  Widget enableUpload() {
//    return Container(
//      child: Column(
//        children: <Widget>[
//          Image.memory(_mediaData.data, height: 300.0, width: 300.0),
//          RaisedButton(
//            elevation: 7.0,
//            child: Text('Upload'),
//            textColor: Colors.white,
//            color: Colors.blue,
//            onPressed: () async {
//              final filePath = 'images/${DateTime.now()}.png';
//              _uploadTask = fb.storage().refFromURL('gs://ecommerce-app-bb2d6.appspot.com').child(filePath).put(_mediaData.data, fb.UploadMetadata(contentType: 'image/jpg'));
//
//              _uploadTask.future.then((snapshot) => snapshot.ref.getDownloadURL().then((uri) => print('URL Is $uri')));
//
////              setState(() {
////                String mimeType = mime(Path.basename(_mediaData.fileName));
//////                var metadata = UploadMetadata(contentType: mimeType);
////                _uploadTask = fb.storage().refFromURL('gs://ecommerce-app-bb2d6.appspot.com').child(filePath).put(_mediaData.data, fb.UploadMetadata(contentType: 'image/jpg'));
//////                _uploadTask.snapshot.ref.getDownloadURL().then((value) => print('URL Is $Uri'));
////              });
//            },
//          ),
////          StreamBuilder<fb.UploadTaskSnapshot>(
////              stream: _uploadTask?.onStateChanged,
////              builder: (context, snapshot) {
////
////                final event = snapshot.data;
//////                if(event!= null && event.ref != null)
//////                    event.ref.getDownloadURL().then((value) => print('URL Is $Uri'));
////
////                double progressPercent = event != null ? event.bytesTransferred / event.totalBytes * 100 : 0;
////                switch (event?.state) {
////                  case fb.TaskState.RUNNING:
////                    return LinearProgressIndicator(
////                      value: progressPercent,
////                    );
////                  case fb.TaskState.SUCCESS:
////                    return Text('Success 🎊');
////
////                  case fb.TaskState.ERROR:
////                    return Text('Has error 😢');
////
////                  default:
////                    // Show empty when not uploading
////                    return SizedBox();
////                }
////              }),
//        ],
//      ),
//    );
//  }
//}
