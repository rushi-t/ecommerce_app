import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:uuid/uuid.dart';

class CartItem {
  String uid = Uuid().v1();
  String userId;
  Product product;
  int quantity;

  CartItem({this.userId, this.product, this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'userId': this.userId,
      'product': this.product.toJson(),
      'quantity': this.quantity,
    };
  }

  CartItem.fromFireBaseSnapshot(Map snapshot)
      : uid = snapshot['uid'],
        userId = snapshot['userId'],
        product = Product.fromJson(snapshot['product']),
        quantity = snapshot['quantity'];
}
