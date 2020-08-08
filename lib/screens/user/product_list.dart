import 'dart:math';

import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/user/product_tile.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/localization.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';

class ProductList extends StatefulWidget {
  Category category;
  String searchText;
  Filter filter;

  ProductList({this.category, this.searchText}) : filter = Filter(category: category);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String getTitle() {
    if (widget.searchText?.isNotEmpty ?? false) {
      return "Search results for \"" + widget.searchText + "\"";
    } else if (widget.category != null) {
      return widget.category.name;
    } else {
      return Localization.of(context).translate('all_products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          width: getScreenWidth(context),
          child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//                WidgetsBinding.instance.addPostFrameCallback((_) => Scaffold.of(context).openEndDrawer());
                return <Widget>[
                  SliverAppBar(
                    pinned: false,
                    floating: false,
                    snap: false,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: primaryColor,
                    title: Text(getTitle()),
                    actions: [
                      IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: white,
                        ),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      )
                    ],
                  ),
                ];
              },
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: searchBarHeight),
                    padding: EdgeInsets.only(top: 10),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        StreamBuilder(
                            stream: ProductService().filterStream(categoryList: widget.filter.categories, searchStr: widget.searchText),
                            builder: (context, snapshot) {
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
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(10),
                      height: searchBarHeight,
                      child: SearchBar(
                        value: widget.searchText,
                        onSubmitted: (value) {
                         setState(() { });
                        },
                        onChanged: (searchText) {
                          widget.searchText = searchText;
                        },
                      )),
                ],
              )),
        ),
      ),
      endDrawer: SafeArea(
        child: Container(
          width: 400,
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 60,
                  child: DrawerHeader(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        FlatSecondaryBtn("Apply", (){
                          Navigator.pop(context);
                          setState(() {});
                        },)
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Categories',
                              style: h4,
                            ),
                            widget.filter
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Filter extends StatefulWidget {
  List<Category> categories = [];

  Filter({Category category}) {
    if (category != null) this.categories.add(category);
  }

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
//    super.build(context);
//    print(widget.categories);
    return StreamBuilder<List<Category>>(
        stream: CategoryService().categoriesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> categoryList = snapshot.data;
            return ChipsChoice<Category>.multiple(
              value: widget.categories,
              options: ChipsChoiceOption.listFrom<Category, Category>(
                source: categoryList,
                value: (i, v) => v,
                label: (i, v) => v.name,
              ),
              onChanged: (val) async => setState(() {
//                print(val);
                setState(() {
                  widget.categories = val;
                });
//                tags = val;
//                recalculatePrice();
              }),
              itemConfig: ChipsChoiceItemConfig(
                selectedColor: primaryColor,
                selectedBrightness: Brightness.dark,
                unselectedColor: primaryColor,
                unselectedBorderOpacity: .3,
              ),
              isWrapped: true,
            );
          }
          return Container();
        });
  }
}
