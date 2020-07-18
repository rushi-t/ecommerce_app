import 'package:ecommerce_app/models/cart_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemService {
  CartItemService();

  // collection reference
  final CollectionReference cartItemCollection =
      Firestore.instance.collection('cart_items');

  Future<void> createCartItem(CartItem cartItem) async {
    print(cartItem.uid);
    return await cartItemCollection.document(cartItem.uid).setData(cartItem.toMap());
  }

  Future<void> updateCartItem(CartItem cartItem) async {
    return await cartItemCollection.document(cartItem.uid).setData(cartItem.toMap());
  }

  Future<void> deleteCartItem(CartItem cartItem) async {
    return await cartItemCollection.document(cartItem.uid).delete();
  }

  // CartItem list from snapshot
  List<CartItem> _cartItemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((documentSnapshot) {
      return CartItem.fromFireBaseSnapshot(documentSnapshot.data);
    }).toList();
  }

  // get categories stream
  Stream<List<CartItem>> cartItemStream({ String userId}){
    return cartItemCollection.where("userId", isEqualTo: userId).snapshots().map(_cartItemListFromSnapshot);
  }
}
