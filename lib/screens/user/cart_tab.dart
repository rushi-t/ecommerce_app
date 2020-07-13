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
import 'package:flutter/cupertino.dart';
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
  double cartTotal = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: widget._hideButtonController, slivers: <Widget>[
      getHomeAppBar(),
      user == null
          ? SliverFillRemaining(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You are not Signed in", style: primaryTextStyleDark),
                  FlatBtn('Sign In', () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: Auth(Home())));
                  })
                ],
              )),
            )
          : StreamBuilder<List<CartItem>>(
              stream: CartItemService().cartItemStream(userId: user.uid),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                        (context, index) => CartTile(cartItem: snapshot.data[index]),
                        childCount: snapshot.hasData ? snapshot.data.length : 0,
                      ))
                    : SliverFillRemaining(
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Your cart is empty", style: primaryTextStyleDark)],
                        )),
                      );
              }),
    ]);
  }
}
