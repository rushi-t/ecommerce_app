import 'package:ecommerce_app/screens/authenticate/sign_in.dart';
import 'package:ecommerce_app/screens/user/order_tab.dart';
import 'package:ecommerce_app/screens/user/product_tab.dart';
import 'package:ecommerce_app/shared/buttons.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/fryo_icons.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'cart_tab.dart';

class Home extends StatefulWidget {
  final String pageTitle;

  Home({Key key, this.pageTitle}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      ProductTab(),
      CartTab(),
      Center(child: FlatBtn('My Orders', () async{
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrderTab()));
    }))];


    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            iconSize: 21,
            icon: Icon(Fryo.funnel),
          ),
          backgroundColor: primaryColor,
          title: Text('eMarket', style: logoWhiteStyle, textAlign: TextAlign.center),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {},
              iconSize: 21,
              icon: Icon(Fryo.magnifier),
            ),
            IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () {},
              iconSize: 21,
              icon: Icon(Fryo.alarm),
            )
          ],
        ),
        body: _tabs[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
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
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

