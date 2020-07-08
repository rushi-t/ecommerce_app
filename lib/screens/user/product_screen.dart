import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/widget/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  ProductTile({ this.product });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: product.imgUrl == null || product.imgUrl == ""
                ? CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[200],
              backgroundImage: AssetImage('assets/coffee_icon.png'),
            )
                : CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[200],
              backgroundImage: NetworkImage(product.imgUrl),
            ),
            title: Text(product.name),
            subtitle: Text(product.description),
            trailing: IconButton(
                icon: new Icon(Icons.add),
                onPressed: () async {
                      User user = Provider.of<User>(context);
                      if(user != null){
                        await CartItemService().createCartItem(CartItem(userId: user.uid, product: product, quantity: 1));
                        print(product.name + " Added");
                        print(CartItemService().cartItemStream(userId: user.uid));
                      }
                  }
            )
        ),
      ),
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context) ?? [];
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductTile(product: products[index]);
      },
    );
  }
}

class ProductScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    return StreamProvider<List<Product>>.value(
      value: ProductService().productsStream,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Products'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ProductList()
        ),
        drawer: SideDrawer(),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.shopping_cart),
            onPressed: () {
              print("Cart");
              Navigator.pushNamed(context, '/user/cart');
            }
        ),
      ),
    );
  }
}