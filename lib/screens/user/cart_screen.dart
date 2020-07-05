import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/admin/product_form.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTile extends StatefulWidget {
  CartItem cartItem;
  CartTile({ this.cartItem });

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: widget.cartItem.product.imgUrl == null || widget.cartItem.product.imgUrl == ""
                ? CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[200],
              backgroundImage: AssetImage('assets/coffee_icon.png'),
            )
                : CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[200],
              backgroundImage: NetworkImage(widget.cartItem.product.imgUrl),
            ),
            title: Text(widget.cartItem.product == null ? '' : widget.cartItem.product.name),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Text("-"),
                    onTap: () async {
                      if(widget.cartItem.quantity>1) {
                        --widget.cartItem.quantity;
                        await CartItemService().updateCartItem(widget.cartItem);
                        print(widget.cartItem.product.name + " Modified");
                      }
                    },
                  ),
                ),
                Text(widget.cartItem.quantity.toString()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: Text("+"),
                    onTap: () async {
                      ++widget.cartItem.quantity;
                      await CartItemService().updateCartItem(widget.cartItem);
                      print(widget.cartItem.product.name + " Modified");
                    },
                  ),
                ),
              ],
            ),
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await CartItemService().deleteCartItem(widget.cartItem);
                  print(widget.cartItem.product.name + " Deleted");
                },
            )
        ),
      ),
    );
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

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
   @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamProvider<List<CartItem>>.value(
      value: CartItemService().cartItemStream(userId: user.uid),
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Cart'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: CartItemList()
        ),

      ),
    );
  }
}