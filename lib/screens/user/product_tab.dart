import 'package:ecommerce_app/screens/user/product_list.dart';
import 'package:ecommerce_app/screens/user/product_tile.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/category.dart';
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
        getHomeAppBar("eRestro"),
        SliverToBoxAdapter(
            child: Container(
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

        SliverToBoxAdapter(child: Container(height: 50.0, child: sectionHeader('All Dishes', onViewMore: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ProductList(
                  )));
        }))),
        StreamBuilder(
            stream: ProductService().productsStream,
            builder: (context, snapshot) {
//                print(MediaQuery.of(context).size.width / 3);
              double cardWidth = MediaQuery
                  .of(context)
                  .orientation == Orientation.portrait ? MediaQuery
                  .of(context)
                  .size
                  .width / 3 : 170;
              int cardCount = MediaQuery
                  .of(context)
                  .orientation == Orientation.portrait ? 3 : MediaQuery
                  .of(context)
                  .size
                  .width ~/ 170;
              return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cardCount, mainAxisSpacing: 0, crossAxisSpacing: 0, childAspectRatio: 0.75),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductTile(snapshot.data[index], cardWidth),
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
