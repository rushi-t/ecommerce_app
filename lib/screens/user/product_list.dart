import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/user/product_tile.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              floating: false,
              snap: false,
              leading: new Container(),
              backgroundColor: primaryColor,
              title: Text(""),
            ),
            StreamBuilder(
                stream: ProductService().productsStream,
                builder: (context, snapshot) {
//                print(MediaQuery.of(context).size.width / 3);
                  double cardWidth = MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width / 3 : 170;
                  int cardCount = MediaQuery.of(context).orientation == Orientation.portrait ? 3 : MediaQuery.of(context).size.width ~/ 170;
                  return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cardCount, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.75),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductTile(snapshot.data[index], cardWidth),
                        childCount: snapshot.hasData ? snapshot.data.length : 0,
                      ));
                })
          ],
        ));
  }
}
