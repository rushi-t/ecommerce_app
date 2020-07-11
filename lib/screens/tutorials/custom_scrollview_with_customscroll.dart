import 'dart:math';

import 'package:ecommerce_app/screens/user/home.dart';
import 'package:ecommerce_app/screens/user/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/user/product_screen.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/fryo_icons.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomScrollViewTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      CustomScrollView(
        slivers: <Widget>[
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
//          StreamBuilder(
//              stream: ProductService().productsStream,
//              builder: (context, snapshot) => SliverList(
//                      delegate: SliverChildBuilderDelegate(
//                    (context, index) => ProductsListItem(product: snapshot.data[index]),
//                    childCount: snapshot.hasData ? snapshot.data.length : 0,
//                  )))

          SliverToBoxAdapter(child: Container(height: 50.0, child: sectionHeader('Products', onViewMore: () {}))),
          StreamBuilder(
              stream: ProductService().productsStream,
              builder: (context, snapshot) => SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width > 600 ? 6 : 2),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductsListItem(product: snapshot.data[index]),
                    childCount: snapshot.hasData ? snapshot.data.length : 0,
                  )))
        ],
      ),
    );
  }
}

class ProductsListItem extends StatelessWidget {
  final Product product;

  ProductsListItem({this.product});

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
    return InkWell(
      onTap: () {
//        Navigator.of(context).pushNamed(Constants.ROUTE_PRODUCT_DETAIL);
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              child: Image.network(
                product.imgUrl,
                fit: BoxFit.fill,
              ),
              width: MediaQuery.of(context).size.width / 2.2,
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    product.name,
                    style: primaryTextStyleDark,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "₹ 199",
                        style: primaryTextStyle,
                      ),
//                      SizedBox(
//                        width: 10.0,
//                      ),
//                      Text(
//                        "₹199",
//                        style: TextStyle(
//                          fontSize: 12.0,
//                          color: Colors.grey,
//                          decoration: TextDecoration.lineThrough,
//                        ),
//                      ),
//                      SizedBox(
//                        width: 8.0,
//                      ),
//                      Text(
//                        "2% off",
//                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
//                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
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