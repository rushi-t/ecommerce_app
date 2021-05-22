import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/order_detail.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/order.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class OrderTile extends StatefulWidget {
  Order order;
  OrderTile({this.order});

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrderDetail(order: widget.order,)));},
      child: Container(
          margin: EdgeInsets.all(5.0),
          decoration: cardDecoration,
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                child: widget.order.items.first.product.imgUrl == null
                    ? Image.asset('assets/plate.jpg')
                    : Image.network(
                        widget.order.items.first.product.imgUrl,
                        fit: BoxFit.cover,
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
          )),
    );
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
                    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Auth(null))).then((isRefresh) {
                      if (isRefresh)
                        setState(() {
                          user = AuthService().userInstance;
                        });
                    });
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
