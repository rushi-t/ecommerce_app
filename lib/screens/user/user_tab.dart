import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/feedback.dart' as fm;
import 'package:ecommerce_app/screens/admin/category_screen.dart';
import 'package:ecommerce_app/screens/admin/product_screen.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/feedback.dart' as fb;
import 'package:ecommerce_app/shared/constants.dart';
import 'package:ecommerce_app/shared/localization.dart';
import 'package:ecommerce_app/shared/widgets.dart';
import 'package:ecommerce_app/widget/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:ecommerce_app/services/product.dart';
import 'package:ecommerce_app/shared/colors.dart';
import 'package:ecommerce_app/shared/fryo_icons.dart';
import 'package:ecommerce_app/shared/styles.dart';
import 'package:ecommerce_app/shared/inputFields.dart';
import 'package:ecommerce_app/services/user.dart';
import 'package:ecommerce_app/screens/user/user_form.dart';
import 'package:page_transition/page_transition.dart';

import 'order_tab.dart';

class UserTab extends StatefulWidget {
  ScrollController _hideButtonController;

  UserTab(this._hideButtonController);

  static final bool updateProfile = false;

  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  User userData = AuthService().userInstance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        // stream: UserProfileService(uid: "whH3upwE3lOVfGHYYzOx6T34PLt1").userProfileData,
        stream: AuthService().user,
        builder: (context, snapshot) {
//          print(AuthService().userInstance);
          if (snapshot.hasData) {
            userData = snapshot.data;
            print("userData = " + userData.email);
          }
          return CustomScrollView(controller: widget._hideButtonController, slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  UserInfoVersion2(userData: userData),
                ],
              ),
            )
          ]);
        });
  }
}

class UserInfoVersion2 extends StatelessWidget {
  User userData;

  UserInfoVersion2({this.userData});

  Widget buildRow(String title, String text) {
    return Container(
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
          width: 200, //                              margin: EdgeInsets.only(right:20.0),
          child: Text(
            title,
            //style: TextStyle(color: Color(0xff053e57), fontSize: 16, fontWeight: FontWeight.w500),
            style: primaryTextStyleDark,
          ),
        ),
        Expanded(
          child: Text(
            text,
            //style: TextStyle(color: Colors.grey[600]),
            style: categoryText,
          ),
        )
      ]),
    );
  }

  Widget showLink(String text, onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                text,
                style: primaryTextStyleDark,
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          Container(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Profile Settings",
                    //style:  TextStyle(color: Color(0xff053e57), fontSize: 16, fontWeight: FontWeight.w700),
                    style: h4,
                    textAlign: TextAlign.left,
                  ),
                  IconButton(
                    icon: new Icon(Icons.edit),
                    highlightColor: Colors.grey,
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                              child: UserForm(),
                            );
                          });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              buildRow("Name", userData != null ? userData.name : ""),
              buildRow("Phone", userData != null ? userData.phone : ""),
              buildRow("Email", userData != null ? userData.email : ""),
              buildRow("Address", userData != null ? userData.address : ""),
            ]),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Other Settings",
                  //style:  TextStyle(color: Color(0xff053e57), fontSize: 16, fontWeight: FontWeight.w700),
                  style: h4,
                ),
                SizedBox(
                  height: 10,
                ),
                showLink("My Orders", () {
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrderTab()));
                }),
                showLink("Sign Out", () {
                  AuthService().signOut().then((value) => showSnackBar(context, "Signed out"));
                }),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Admin",
                  //style:  TextStyle(color: Color(0xff053e57), fontSize: 16, fontWeight: FontWeight.w700),
                  style: h4,
                ),
                SizedBox(
                  height: 10,
                ),
                showLink("Manage Categories", () {
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CategoryScreen()));
                }),
                showLink("Manage Products", () {
                  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ProductScreen()));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
