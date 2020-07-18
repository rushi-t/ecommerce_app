import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/services/order.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ecommerce_app/screens/user/home.dart';

class OrderItemTile extends StatefulWidget {
  CartItem cartItem;

  OrderItemTile({this.cartItem});

  @override
  _OrderItemTileState createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8.0),
        decoration: cardDecoration,
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: widget.cartItem.product.imgUrl == null
                  ? Image.asset('assets/plate.jpg')
                  : Image.network(
                      widget.cartItem.product.imgUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          widget.cartItem.product.name,
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
                              "x " + (widget.cartItem.quantity).toString(),
                              style: primaryTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "₹ " + (widget.cartItem.product.price).toString(),
                      style: primaryTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class OrderDetail extends StatefulWidget {
  Order order;

  OrderDetail({this.order});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  Step _buildStep({
    @required Widget title,
    StepState state = StepState.indexed,
    bool isActive = false,
  }) {
    return Step(
      title: title,
      state: state,
      isActive: isActive,
      content: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text("Order- " + Order.generateOrderId(widget.order.dateTime)),
          backgroundColor: primaryColor,
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: StreamBuilder<Order>(
          stream: OrderService().orderStream(widget.order.uid),
          builder: (context, snapshot) {
            widget.order = snapshot.data;
            if(!snapshot.hasData){
              return Container();
            }
            else
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.order.items.length,
                    itemBuilder: (context, index) {
                      //        print(cartItems[index].product);
                      return OrderItemTile(cartItem: widget.order.items[index]);
                    },
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, .2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Status: " + orderStatusList[widget.order.status],
                              style: primaryTextStyleDark,
                            ),
                          ],
                        ),
                        Text(
                          "Total: ₹" + widget.order.total.toString(),
                          style: primaryTextStyle,
                        ),
                      ],
                    ))
              ],
            );
          }
        ));
  }
}
