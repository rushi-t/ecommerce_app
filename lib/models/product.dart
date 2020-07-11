import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Product {
  String uid = Uuid().v1();
  String name;
  String imgUrl;
  double price;
  bool enabled = true;
  String description;
  String categoryUid;

  Product({this.name, this.imgUrl, this.price, this.enabled, this.description, this.categoryUid});

  Map<String, dynamic> toMap() {
    return {'uid': this.uid,'name': this.name, 'imgUrl': this.imgUrl, 'price': this.price, 'enabled': this.enabled, 'description': this.description, 'categoryUid': this.categoryUid};
  }

  Product.fromFireBaseSnapshot(Map snapshot)
      : uid = snapshot['uid'],
        name = snapshot['name'],
        imgUrl = snapshot['imgUrl'],
        price = snapshot['price'],
        enabled = true,
        description = snapshot['description'],
        categoryUid = snapshot['categoryUid'];
}
