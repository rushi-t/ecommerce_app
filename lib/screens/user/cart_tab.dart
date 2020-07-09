import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                      style: foodNameText,
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
                          style: priceText,
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
                          onTap: () async{
                            ++widget.cartItem.quantity;
                            await CartItemService().updateCartItem(widget.cartItem);
                            print(widget.cartItem.product.name + " Modified");
                          },
                          child: Icon(
                            Icons.add,
                            color: primaryColorDark,
                          )),
                    ),
                    Text(widget.cartItem.quantity.toString(), style: foodNameText,),
                    Container(
                      margin: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), border: Border.all(width: 2, color: primaryColorDark)),
                      child: GestureDetector(
                          onTap: () async {
                            if(widget.cartItem.quantity>1) {
                              --widget.cartItem.quantity;
                              await CartItemService().updateCartItem(widget.cartItem);
                              print(widget.cartItem.product.name + " Modified");
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
        print(cartItems[index].product);
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
    User user = Provider.of<User>(context);

//    return StreamProvider<List<CartItem>>.value(value: CartItemService().cartItemStream(userId: "M5xzvS3OrVXROwIIsQQfSVCZQ5w2"), child: CartItemList());
    return StreamProvider<List<CartItem>>.value(value: CartItemService().cartItemStream(userId: user.uid), child: CartItemList());
  }
}
