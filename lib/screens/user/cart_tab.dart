import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/services/order.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ecommerce_app/screens/user/home.dart';

class CartTile extends StatefulWidget {
  CartItem cartItem;

  CartTile({this.cartItem});

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
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
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
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
                          "₹ " + (widget.cartItem.product.price * widget.cartItem.quantity).toString(),
                          style: primaryTextStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(width: 2, color: primaryColorDark)),
                      child: GestureDetector(
                          onTap: () async {
                            ++widget.cartItem.quantity;
                            await CartItemService().updateCartItem(widget.cartItem);
                            print(widget.cartItem.product.name + " Modified");
                          },
                          child: Icon(
                            Icons.add,
                            color: primaryColorDark,
                          )),
                    ),
                    Text(
                      widget.cartItem.quantity.toString(),
                      style: primaryTextStyleDark,
                    ),
                    Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(width: 2, color: primaryColorDark)),
                      child: GestureDetector(
                          onTap: () async {
                            if (widget.cartItem.quantity > 1) {
                              --widget.cartItem.quantity;
                              await CartItemService().updateCartItem(widget.cartItem);
                              print(widget.cartItem.product.name + " Modified");
                            } else {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: new Text("Do you want to remove item from cart?", style: primaryTextStyleDark),
                                        actions: <Widget>[
                                          new FlatButton(
                                            child: Text("Cancel", style: TextStyle(color: primaryColor)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          new FlatButton(
                                            child: new Text(
                                              "Continue",
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                            onPressed: () async {
                                              await CartItemService().deleteCartItem(widget.cartItem);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ));
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            color: primaryColorDark,
                          )),
                    )
                  ],
                )),
          ],
        ));
  }
}

class CartTab extends StatefulWidget {
  ScrollController _hideButtonController;

  CartTab(this._hideButtonController);

  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  User user = AuthService().userInstance;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Center(
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
        ));
    } else {
      return StreamBuilder<List<CartItem>>(
          stream: CartItemService().cartItemStream(userId: user.uid),
          builder: (context, snapshot) {
            double cartTotal = 0;
            snapshot.data?.forEach((cartItem) => cartTotal += (cartItem.product.price * cartItem.quantity));
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(controller: widget._hideButtonController, slivers: <Widget>[
                    getHomeAppBar("eRestro"),
                    if (snapshot.hasData && snapshot.data.length > 0)
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                        (context, index) => CartTile(cartItem: snapshot.data[index]),
                        childCount: snapshot.hasData ? snapshot.data.length : 0,
                      ))
                    else
                      SliverFillRemaining(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Your cart is empty", style: primaryTextStyleDark)],
                        )),
                      )
                  ]),
                ),
                if (snapshot.hasData && snapshot.data.length > 0)
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
                    padding: EdgeInsets.only(left: 30, right: 30),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Total:  ₹" + cartTotal.toString(),
                          style: primaryTextStyleDark,
                        ),
                        FlatBtn("Order Now", () async {
                          if (snapshot.hasData) {
                            Order order = Order(userId: user.uid, items: snapshot.data, total: cartTotal, status: 0);
                            print(order.toMap());
                            await OrderService().createOrder(order);
                            snapshot.data.forEach((cartItem) {
                              CartItemService().deleteCartItem(cartItem);
                            });
                            showSnackBar(context, "Order placed");
                          }
                        }),
                      ],
                    ))
              ],
            );
          });
    }
  }
}
