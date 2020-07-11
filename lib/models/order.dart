import 'package:uuid/uuid.dart';
import 'cart_item.dart';
import 'package:intl/intl.dart';

class Order {
  String uid = Uuid().v1();
  DateTime dateTime = DateTime.now();
  String userId = '';
  List<CartItem> items;
  double total;

  Order({this.userId, this.items, this.total});

  List<Map<String, dynamic>> toCartItemMap() {
    List<Map<String, dynamic>> cartItemList = List<Map<String, dynamic>>();
    this.items.forEach((cartItem) => cartItemList.add(cartItem.toMap()));
    return cartItemList;
  }

  static List<CartItem> fromFireBaseSnapShotToCartList(List<dynamic> cartItemList) {
    List<CartItem> items = List<CartItem>();
    cartItemList.forEach((cartItem) => items.add(CartItem.fromFireBaseSnapshot(cartItem)));
    return items;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'dateTime': this.dateTime,
      'userId': this.userId,
      'items': toCartItemMap(),
      'total': this.total,
    };
  }

  Order.fromFireBaseSnapshot(Map snapshot)
      : uid = snapshot['uid'],
        dateTime = snapshot['dateTime'].toDate(),
        userId = snapshot['userId'],
        items = fromFireBaseSnapShotToCartList(snapshot['items']),
        total = snapshot['total'];

  static String generateOrderId( DateTime dateTime) {
    final DateFormat formatter = DateFormat('ddMMyy-HHmmss');
    final String orderId = formatter.format(dateTime);
    return orderId;
  }
}
