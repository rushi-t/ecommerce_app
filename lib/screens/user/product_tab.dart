import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/screens/authenticate/sign_in.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/cart_item.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/fryo_icons.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

class ProductTab extends StatelessWidget {
  ScrollController _hideButtonController;

  ProductTab(this._hideButtonController);

  @override
  Widget build(BuildContext context) {
//    print("Orientation= " + MediaQuery.of(context).orientation.toString());
    return CustomScrollView(
        controller: _hideButtonController,
        slivers: <Widget>[
          getHomeAppBar(),
          SliverToBoxAdapter(
              child: Container(
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      sectionHeader('Categories', onViewMore: () {}),
                      SizedBox(
                        height: 130,
                        child: CategoryScroller(),
                      )
                    ],
                  ))),

          SliverToBoxAdapter(child: Container(height: 50.0, child: sectionHeader('Products', onViewMore: () {}))),
          StreamBuilder(
              stream: ProductService().productsStream,
              builder: (context, snapshot) {
//                print(MediaQuery.of(context).size.width / 3);
                double cardWidth = MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width / 3 : 170;
                int cardCount = MediaQuery.of(context).orientation == Orientation.portrait ? 3 : MediaQuery.of(context).size.width ~/ 170;
                return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cardCount, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.75),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductsListItem(snapshot.data[index], cardWidth),
                      childCount: snapshot.hasData ? snapshot.data.length : 0,
                    ));
              })
//          StreamBuilder(
//              stream: ProductService().productsStream,
//              builder: (context, snapshot) => SliverStaggeredGrid(
//                  gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
//                      crossAxisCount: 4,
//                      mainAxisSpacing: 3,
//                      crossAxisSpacing: 4,
//                      staggeredTileBuilder: (int index) => StaggeredTile.fit(4)),
//                  delegate: SliverChildBuilderDelegate(
//                        (context, index) => ProductsListItem(product: snapshot.data[index]),
//                    childCount: snapshot.hasData ? snapshot.data.length : 0,
//                  )))
        ],
      );
  }
}

class ProductsListItem extends StatelessWidget {
  final Product product;
  final double cardWidth;

  ProductsListItem(this.product, this.cardWidth);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildProductItemCard(context),
//        _buildProductItemCard(context),
      ],
    );
  }

  _buildProductItemCard(BuildContext context) {
//    print("cardWidth= " + cardWidth.toString());
    return Container(
      width: cardWidth,
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: product.imgUrl != null && product.imgUrl != ""
                  ? Image.network(
                      product.imgUrl,
                      width: cardWidth,
                      fit: BoxFit.fill,
                    )
                  : Image.asset(
                      "assets/plate.jpg",
                      width: cardWidth,
                      fit: BoxFit.fill,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    product.name,
                    style: primaryTextStyleDark,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "₹ " + (product.price != null ? product.price.toString() : "0"),
                        style: primaryTextStyle,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        child: FloatingActionButton(
                          backgroundColor: primaryColor,
                          elevation: 0,
                          child:Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          onPressed: () async{
                            if(!AuthService().isLoggedIn()) {
                              Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SignIn(null)));
                            }
                            else{
                              await CartItemService().createCartItem(CartItem(userId: AuthService().userInstance.uid, product: product, quantity: 1));
                              showSnackBar(context, 'Item added to your cart');
                          }}
                        ),

//                          child:FlatBtn('Add', () async{
//                            if(!AuthService().isLoggedIn()) {
//                              Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SignIn(null)));
//                            }
//                            else{
//                              await CartItemService().createCartItem(CartItem(userId: AuthService().userInstance.uid, product: product, quantity: 1));
//                              showSnackBar(context, 'Item added to your cart');
//                            }
//                          })
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;

  CategoryTile({this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10),
              width: 86,
              height: 86,
              child: FloatingActionButton(
                shape: CircleBorder(),
                heroTag: category.name,
                onPressed: () {},
                backgroundColor: white,
                child: category.imgUrl == null || category.imgUrl == "" ? Icon(Fryo.dinner, size: 35, color: Colors.black87) : Image.network(category.imgUrl),
              )),
          Text(category.name + ' ›', style: categoryText)
        ],
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context) ?? [];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryTile(category: categories[index]);
      },
    );
  }
}

class CategoryScroller extends StatefulWidget {
  @override
  _CategoryScrollerState createState() => _CategoryScrollerState();
}

class _CategoryScrollerState extends State<CategoryScroller> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Category>>.value(
      value: CategoryService().categoriesStream,
      child: CategoryList(),
    );
  }
}

Widget sectionHeader(String headerTitle, {onViewMore}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Container(
        margin: EdgeInsets.only(left: 15, top: 10),
        child: Text(headerTitle, style: h4),
      ),
      Container(
        margin: EdgeInsets.only(left: 15, top: 2),
        child: FlatButton(
          onPressed: onViewMore,
          child: Text('View all ›', style: contrastText),
        ),
      )
    ],
  );
}
