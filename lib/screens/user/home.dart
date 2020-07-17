import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/screens/user/order_tab.dart';
import 'package:ecommerce_app/screens/user/product_tab.dart';
import 'package:ecommerce_app/screens/user/user_tab.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/fryo_icons.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';

import 'cart_tab.dart';

class Home extends StatefulWidget {
  final String pageTitle;

  Home({Key key, this.pageTitle}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  ScrollController _hideButtonController;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
//      print("listener");
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
//          print("**** $_isVisible up");
        });
      }
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
//          print("**** $_isVisible down");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      ProductTab(_hideButtonController),
      CartTab(_hideButtonController),
      UserTab(_hideButtonController),
//      Center(
//          child: Column(
//        children: [
//          FlatBtn('My Orders', () async {
//            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrderTab()));
//          }),
//          SizedBox(height: 10,),
//          FlatBtn('Logout', () async {
//            AuthService().signOut().then((value) => showSnackBar(context, "Logged out"));
//          })
//        ],
//      ))
    ];

    return Scaffold(
        backgroundColor: bgColor,
        body: _tabs[_selectedIndex],
        bottomNavigationBar: Container(
//          height: _isVisible ? 60 : 0.0,
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Fryo.shop),
                  title: Text(
                    'Store',
                    style: tabLinkStyle,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Fryo.cart),
                  title: Text(
                    'My Cart',
                    style: tabLinkStyle,
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Fryo.user_1),
                  title: Text(
                    'Profile',
                    style: tabLinkStyle,
                  )),
            ],
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.green[600],
            onTap: _onItemTapped,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
