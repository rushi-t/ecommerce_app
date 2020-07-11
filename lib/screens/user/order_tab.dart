import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/sign_in.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/services/order.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ecommerce_app/screens/user/home.dart';

class OrderTile extends StatefulWidget {
  Order order;

  OrderTile({this.order});

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        decoration: cardDecoration,
        child: Row(
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: widget.order.items.first.product.imgUrl == null
                    ? CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: AssetImage('assets/plate.jpg'),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(widget.order.items.first.product.imgUrl),
                      ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Order ID: " + Order.generateOrderId(widget.order.dateTime),
                      style: primaryTextStyleDark,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Total: ₹" + (widget.order.total).toString(),
                          style: primaryTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class OrderTab extends StatefulWidget {
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  User user = AuthService().userInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('My Orders'),
          backgroundColor: primaryColor,
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: user == null
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You are not Signed in", style: primaryTextStyleDark),
                  FlatBtn('Sign In', () {
                    Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, duration: Duration(seconds: 1), child: SignIn(Home())));
                  })
                ],
              ))
            : StreamBuilder<List<Order>>(
//                stream: OrderService().userOrderStream("M5xzvS3OrVXROwIIsQQfSVCZQ5w2"),
              stream: OrderService().userOrderStream(user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else {
                    List<Order> orderItems = snapshot.data;
                    if (orderItems.length == 0) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text("You haven't order anything yet, place your first order", style: primaryTextStyleDark)],
                      ));
                    } else {
                      return Column(children: [
                        Expanded(
                            child: ListView.builder(
                          itemCount: orderItems.length,
                          itemBuilder: (context, index) {
                            //        print(cartItems[index].product);
                            return OrderTile(order: orderItems[index]);
                          },
                        )),
                      ]);
                    }
                  }
                }));
  }
}
