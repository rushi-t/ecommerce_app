import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase/firebase.dart' as fb;

class StorageService {
  StorageService();

  Future<Uri> createImage(MediaInfo imageData, String path, String imageName) async {
    final filePath = '$path/$imageName.png';
    dynamic uploadTask = fb.storage().refFromURL('gs://ecommerce-app-bb2d6.appspot.com').child(filePath).put(imageData.data, fb.UploadMetadata(contentType: 'image/jpg'));
    dynamic snapshot = await uploadTask.future;
    return snapshot.ref.getDownloadURL();
  }

  Future<dynamic> deleteImage(MediaInfo imageData, String path, String imageName) async {
    final filePath = '$path/$imageName.png';
    return fb.storage().refFromURL('gs://ecommerce-app-bb2d6.appspot.com').child(filePath).delete();
  }
}
