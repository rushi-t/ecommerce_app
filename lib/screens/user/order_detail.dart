import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/services/order.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        margin: EdgeInsets.only(top: 10.0),
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
//  int changeOrderStatus;
//
  OrderDetail({this.order});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  String radioItem = "0";

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

  // user defined function
  void _showDialog() {
    // flutter defined function

    showDialog(
        context: context,
        builder: (context) {
          final ingredientFormKey = GlobalKey<FormState>();
          String userName;
          String userPhone;
          String userAddress;
          return AlertDialog(
            //title: Text('User Profile'),
            title: Container(
              height: 25,
              child: Row(children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Text('Choose Order Status',style: primaryTextStyleDark),
                SizedBox(
                  width: 60,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                      child: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ]),
            ),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: ingredientFormKey,
                child: Container(
                  height: 230,
                  child: Column(children: <Widget>[
                    RadioListTile(
                      groupValue: widget.order.status,
                      title: Text(orderStatusList[0],style: primaryTextStyle),
                      value: 0,
                      onChanged: (val) {
                        setState(() {
                          widget.order.status = val;
                        });
                      },
                    ),
                    RadioListTile(
                      groupValue: widget.order.status,
                      title: Text(orderStatusList[1],style: primaryTextStyle),
                      value: 1,
                      onChanged: (val) {
                        setState(() {
                          widget.order.status = val;
                        });
                      },
                    ),
                    RadioListTile(
                      groupValue: widget.order.status,
                      title: Text(orderStatusList[2],style: primaryTextStyle),
                      value: 2,
                      onChanged: (val) {
                        setState(() {
                          widget.order.status = val;
                        });
                      },
                    ),
                    RadioListTile(
                      groupValue: widget.order.status,
                      title: Text(orderStatusList[3],style: primaryTextStyle),
                      value: 3,
                      onChanged: (val) {
                        setState(() {
                          widget.order.status = val;
                        });
                      },
                    ),
                  ]),
                ),
              );
            }),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    OrderService().updateOrder(widget.order);
                    Navigator.pop(context);
                  },
                  child: Text('Save',style: primaryTextStyleDark,))
            ],
          );
        }).then((value) => print('Result: ' + value.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text("Order- " + Order.generateOrderId(widget.order.dateTime)),
          backgroundColor: primaryColor,
          elevation: 0.0,
          //actions: <Widget>[],
          actions: [
            IconButton(
              icon: Icon(
                Icons.create,
                color: white,
              ),
              onPressed: () {
                //Scaffold.of(context).openEndDrawer();
                _showDialog();
              },
            )
          ],
        ),
        body: StreamBuilder<Order>(
            stream: OrderService().orderStream(widget.order.uid),
            builder: (context, snapshot) {
              widget.order = snapshot.data;
              if (!snapshot.hasData) {
                return Container();
              } else
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.order.items.length,
                        itemBuilder: (context, index) {
                          //        print(cartItems[index].product);
                          return OrderItemTile(
                              cartItem: widget.order.items[index]);
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
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
                                  "Status: " +
                                      orderStatusList[widget.order.status],
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
            }));
  }
}
