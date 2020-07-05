import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Product {
  String uid = Uuid().v1();
  String name = '';
  String imgUrl = '';
  bool enabled = true;
  String description = '';
  String categoryUid = '';

  Product({this.name, this.imgUrl, this.enabled, this.description, this.categoryUid});

  Map<String, dynamic> toMap() {
    return {'uid': this.uid,'name': this.name, 'imgUrl': this.imgUrl, 'enabled': this.enabled, 'description': this.description, 'categoryUid': this.categoryUid};
  }

  Product.fromFireBaseSnapshot(Map snapshot)
      : uid = snapshot['uid'],
        name = snapshot['name'],
        imgUrl = snapshot['imgUrl'],
        enabled = true,
        description = snapshot['description'],
        categoryUid = snapshot['categoryUid'];
}
