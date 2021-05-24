import 'dart:math';

import 'package:ecommerce_app/screens/user/product_list.dart';
import 'package:ecommerce_app/screens/user/product_tile.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductTab extends StatelessWidget {
  ScrollController _hideButtonController;

  ProductTab(this._hideButtonController);

  @override
  Widget build(BuildContext context) {
//    print("Orientation= " + MediaQuery.of(context).orientation.toString());
    return Stack(children: [
      CustomScrollView(
        controller: _hideButtonController,
        slivers: <Widget>[
//        getHomeAppBar(Localization.of(context).translate('app_title')),
          SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.only(top: searchBarHeight),
                  height: 200.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      sectionHeader('Menu', onViewMore: () {}),
                      SizedBox(
                        height: 130,
                        child: CategoryScroller(),
                      )
                    ],
                  ))),

          SliverToBoxAdapter(
              child: Container(
                  height: 50.0,
                  child: sectionHeader('All Dishes', onViewMore: () {
                    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ProductList()));
                  }))),
          StreamBuilder(
              stream: ProductService().productsStream,
              builder: (context, snapshot) {
//                print("data= "+ snapshot.data.toString());
                double spacing = 6;
//                print(MediaQuery.of(context).size.width / 3);
                double cardWidth = MediaQuery.of(context).orientation == Orientation.portrait ? (MediaQuery.of(context).size.width / 3) - (spacing * 2) : 188;
                int cardCount = MediaQuery.of(context).orientation == Orientation.portrait ? 3 : min(MediaQuery.of(context).size.width, MAX_SCREEN_WIDTH) ~/ 188;
                return SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cardCount, mainAxisSpacing: spacing, crossAxisSpacing: spacing, childAspectRatio: 0.75),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductTile(snapshot.data[index], cardWidth),
                        childCount: snapshot.hasData ? snapshot.data.length : 0,
                      )),
                );
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
      ),
      Container(
          margin: EdgeInsets.all(10),
          height: searchBarHeight,
          child: SearchBar(
            onSubmitted: (value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductList(
                            searchText: value,
                          )));
            },
          )),
    ]);
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;

  CategoryTile({this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ProductList(
                  category: category,
                )));
      },
      child: Container(
        margin: EdgeInsets.only(left: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(margin: EdgeInsets.only(bottom: 10), width: 86, height: 86, child: ClipOval(child: ImageWidget(category.imgUrl, "assets/plate.jpg"))),
            Text(category.name + ' ›', style: categoryText)
          ],
        ),
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
