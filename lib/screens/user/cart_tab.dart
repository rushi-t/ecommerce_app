import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/sign_in.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/services/user.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                            }
                            else{
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
                                      child: new Text("Continue", style: TextStyle(color: Colors.grey),),
                                      onPressed: () async{
                                        await CartItemService().deleteCartItem(widget.cartItem);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                )
                              );


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

class CartItemList extends StatefulWidget {
  @override
  _CartItemListState createState() => _CartItemListState();
}

class _CartItemListState extends State<CartItemList> {
  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<List<CartItem>>(context) ?? [];

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
//        print(cartItems[index].product);
        return CartTile(cartItem: cartItems[index]);
      },
    );
  }
}

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  @override
  Widget build(BuildContext context) {
    User user = AuthService().userInstance;

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
//      return StreamProvider<List<CartItem>>.value(value: CartItemService().cartItemStream(userId: "M5xzvS3OrVXROwIIsQQfSVCZQ5w2"), child: CartItemList());
//      print("UserID = "+ user.uid);
      return StreamProvider<List<CartItem>>.value(value: CartItemService().cartItemStream(userId: user.uid), child: CartItemList());
    }
  }
}
