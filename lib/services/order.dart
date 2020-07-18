import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/models/order.dart';

class OrderService {
  OrderService();

  // collection reference
  final CollectionReference orderCollection =
      Firestore.instance.collection('orders');

  Future<void> createOrder(Order order) async {
    print(order.uid);
    return await orderCollection.document(order.uid).setData(order.toMap());
  }

  Future<void> updateOrder(Order order) async {
    return await orderCollection.document(order.uid).setData(order.toMap());
  }

  Future<void> deleteOrder(Order order) async {
    return await orderCollection.document(order.uid).delete();
  }

  // Order list from snapshot
  List<Order> _orderListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((documentSnapshot) {
      return Order.fromFireBaseSnapshot(documentSnapshot.data);
    }).toList();
  }

  // get categories stream
  Stream<List<Order>> allOrderStream(){
    return orderCollection.snapshots().map(_orderListFromSnapshot);
  }

  Stream<List<Order>> userOrderStream(String userId){
    return orderCollection.where("userId", isEqualTo: userId).snapshots().map(_orderListFromSnapshot);
  }

  Stream<Order> orderStream(String uid) {
    return orderCollection.document(uid).snapshots().map((documentSnapshot) => Order.fromFireBaseSnapshot(documentSnapshot.data));
  }
}
