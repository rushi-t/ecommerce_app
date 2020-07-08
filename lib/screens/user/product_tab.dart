
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/fryo_icons.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:provider/provider.dart';

class ProductTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Orientation= " + MediaQuery.of(context).orientation.toString());
    return Scaffold(
      body: CustomScrollView(
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

          SliverToBoxAdapter(child: Container(height: 50.0, child: sectionHeader('Products', onViewMore: () {}))),
          StreamBuilder(
              stream: ProductService().productsStream,
              builder: (context, snapshot) {
                double cardWidth = MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width / 2 : 270;
                int cardCount = MediaQuery.of(context).orientation == Orientation.portrait ? 2 : MediaQuery.of(context).size.width ~/ 270;
                return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: cardCount, mainAxisSpacing: 0, crossAxisSpacing: 0),
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
      ),
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
    print("cardWidth= " + cardWidth.toString());
    return InkWell(
      onTap: () {
//        Navigator.of(context).pushNamed(Constants.ROUTE_PRODUCT_DETAIL);
      },
      child: Container(
        width: cardWidth,
        child: Card(
          elevation: 4.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Image.network(
                  product.imgUrl,
                  width: cardWidth,
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0, top: 8.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        product.name,
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
                            "₹ 199",
                            style: priceText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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