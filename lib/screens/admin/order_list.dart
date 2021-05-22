import 'dart:math';

import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/order.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/user/order_tab.dart';
import 'package:ecommerce_app/screens/user/product_tile.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/order.dart';
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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../models/user.dart';
import '../../services/auth.dart';

class OrderList extends StatefulWidget {
  Filter filter;
  OrderList() : filter = Filter();

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  User user = AuthService().userInstance;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();

  String getTitle() {
//    if (widget.searchText?.isNotEmpty ?? false) {
//      return "Search results for \"" + widget.searchText + "\"";
//    } else if (widget.order. != null) {
//      return widget.category.name;
//    } else {
//      return Localization.of(context).translate('all_orders');
//    }
    return Localization.of(context).translate('all_orders');
  }

  Future<Null> _selectDate(BuildContext context, String strDateType) async {
    DateTime tmpDate =
        strDateType == "FromDate" ? selectedFromDate : selectedToDate;

//    final DateTime picked = await showDatePicker(
//        context: context,
//
//        initialDate: tmpDate,
//        firstDate: DateTime(2015, 8),
//        lastDate: DateTime(2101));

    final DateTime picked = await showDatePicker(
         context: context,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(primarySwatch: Colors.green),
            child: child,
          );},
        initialDate: tmpDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != tmpDate)
      setState(() {
        tmpDate = picked;
        if (strDateType == "FromDate") {
          selectedFromDate = picked;
          widget.filter.fromDate = picked;
        } else {
          selectedToDate = picked;
          widget.filter.toDate = picked;
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Container(
          width: getScreenWidth(context),
          child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
                    // margin: EdgeInsets.only(top: searchBarHeight),
                    //padding: EdgeInsets.only(top: 10),
                    child: CustomScrollView(
                      slivers: <Widget>[
                        StreamBuilder<List<Order>>(
                            stream: OrderService().filterStream(
                                orderStatusList: widget.filter.orderState,
                                fromDate: widget.filter.fromDate,
                                toDate: widget.filter.toDate),
//                            stream: OrderService().userOrderStream("M5xzvS3OrVXROwIIsQQfSVCZQ5w2"),
                            builder: (context, snapshot) {
                              double spacing = 6;
                              List<Order> orderItems = snapshot.data;
                              print(snapshot.data);
//                print(MediaQuery.of(context).size.width / 3);
                              double cardWidth = MediaQuery.of(context)
                                          .orientation ==
                                      Orientation.portrait
                                  ? (MediaQuery.of(context).size.width / 3) -
                                      (spacing * 2)
                                  : 188;
                              int cardCount =
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 3
                                      : min(MediaQuery.of(context).size.width,
                                              MAX_SCREEN_WIDTH) ~/
                                          188;
                              return SliverPadding(
                                padding: EdgeInsets.all(8.0),
                                sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                  (context, index) =>
                                      OrderTile(order: snapshot.data[index]),
                                  childCount: snapshot.hasData
                                      ? snapshot.data.length
                                      : 0,
                                )),
                              );
                            })
                      ],
                    ),
                  ),
//                  Container(
//                      margin: EdgeInsets.all(10),
//                      height: searchBarHeight,
//                      child: SearchBar(
//                        value: widget.searchText,
//                        onSubmitted: (value) {
//                         setState(() { });
//                        },
//                        onChanged: (searchText) {
//                          widget.searchText = searchText;
//                        },
//                      )),
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
                        FlatSecondaryBtn(
                          "Apply",
                          () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                        )
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
                              'Order Status',
                              style: h4,
                            ),
                            widget.filter,
                            Text(
                              'Date Range',
                              style: h4,
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'From',
                                    style: primaryTextStyleDark,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    "${selectedFromDate.toLocal()}"
                                        .split(' ')[0],
                                    style: primaryTextStyle,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  IconButton(
                                    icon: new Icon(Icons.date_range),
                                    highlightColor: Colors.grey,
                                    onPressed: () =>
                                        _selectDate(context, 'FromDate'),
                                  )
                                ]),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'To',
                                    style: primaryTextStyleDark,
                                  ),
                                  SizedBox(
                                    width: 40.0,
                                  ),
                                  Text(
                                    "${selectedToDate.toLocal()}".split(' ')[0],
                                    style: primaryTextStyle,
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                                  IconButton(
                                    icon: new Icon(Icons.date_range),
                                    highlightColor: Colors.grey,
                                    onPressed: () =>
                                        _selectDate(context, 'ToDate'),
                                  )
                                ])
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
  List<int> orderState = [];
  DateTime fromDate;
  DateTime toDate;

  Filter({DateTime fromDate, DateTime toDate}) {
    fromDate = fromDate;
    toDate = toDate;
  }

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
//    super.build(context);
//    print(widget.categories);
    return ChipsChoice<int>.multiple(
      value: widget.orderState,
      options: ChipsChoiceOption.listFrom<int, String>(
        source: orderStatusList.values.toList(),
        value: (i, v) => i,
        label: (i, v) => v,
      ),
      onChanged: (val) async => setState(() {
                print(val);
        setState(() {
          widget.orderState = val;
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
}
