import 'dart:async';
import 'dart:typed_data';

import 'package:ecommerce_app/widget/utility.dart';

//import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService();

  Future<Uri> createImage(Uint8List imageData, String path, String imageName) async {
    final filePath = '$path/$imageName.png';
    FirebaseStorage storage = FirebaseStorage.instance;

    //Create a reference to the location you want to upload to in firebase
    StorageReference reference = await storage.getReferenceFromUrl('gs://ecommerce-app-bb2d6.appspot.com');
    print(reference.path);
    dynamic uploadTask = reference.child(filePath).putData(imageData, StorageMetadata(contentType: 'image/jpg'));
    await uploadTask.onComplete;
    return reference.getDownloadURL();
  }

  Future<dynamic> deleteImage(String path, String imageName) async {
    final filePath = '$path/$imageName.png';
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference reference = await storage.getReferenceFromUrl('gs://ecommerce-app-bb2d6.appspot.com');
    return reference.child(filePath).delete();
    return null;
  }
}
