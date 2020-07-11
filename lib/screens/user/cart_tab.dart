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
        padding: EdgeInsets.all(8.0),
        decoration: cardDecoration,
        child: Row(
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: widget.cartItem.product.imgUrl == null || widget.cartItem.product.imgUrl == ""
                    ? CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: AssetImage('assets/plate.jpg'),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(widget.cartItem.product.imgUrl),
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
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  User user = AuthService().userInstance;
  double cartTotal = 0;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("You are not Signed in", style: primaryTextStyleDark),
          FlatBtn('Sign In', () {
            Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.leftToRight, duration: Duration(seconds: 1), child: SignIn(Home())));
          })
        ],
      ));
    } else {
      return StreamBuilder<List<CartItem>>(
//          stream: CartItemService().cartItemStream(userId: "M5xzvS3OrVXROwIIsQQfSVCZQ5w2"),
          stream: CartItemService().cartItemStream(userId: user.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            else {
              List<CartItem> cartItems = snapshot.data;
              if (cartItems.length == 0) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Your cart is empty", style: primaryTextStyleDark)],
                ));
              } else {
                cartTotal = 0;
                cartItems.forEach((cartItem) => cartTotal += (cartItem.product.price * cartItem.quantity));
                return Column(children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      //        print(cartItems[index].product);
                      return CartTile(cartItem: cartItems[index]);
                    },
                  )),
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
                            Order order = Order(userId: user.uid, items: cartItems, total: cartTotal);
                            await OrderService().createOrder(order);
                            cartItems.forEach((cartItem) {
                              CartItemService().deleteCartItem(cartItem);
                            });
                            showSnackBar(context, "Order placed");
                          }),
                        ],
                      )),
                ]);
              }
            }
          });
    }
  }
}
