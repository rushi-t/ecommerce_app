import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/models/feedback.dart' as fm;
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/feedback.dart' as fb;
import 'package:ecommerce_app/shared/constants.dart';
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

  //static final String path = "lib/src/pages/profile/profile8.dart";
  static final bool updateProfile = false;

  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  User userData = AuthService().userInstance;
  final List<String> avatars = [
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F4.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F6.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F7.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fdev_damodar.jpg?alt=media&token=aaf47b41-3485-4bab-bcb6-2e472b9afee6',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fdev_sudip.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2Fdev_sid.png?alt=media',
  ];

  final List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F2.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F3.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F4.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F5.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F6.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F7.jpg?alt=media',
  ];

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
            getHomeAppBar("eRestro"),
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
//                    ProfileHeader(
//                      avatar: NetworkImage(avatars[0]),
//                      coverImage: NetworkImage(images[1]),
//                      title: userData == null ? "" : userData.name,
//                      //subtitle: "Manager",
//                      actions: <Widget>[],
//                    ),
//                    //const SizedBox(height: 10.0),
                  UserInfoVersion2(userData: userData),
                  //UserInfo(userData: userData),

                  //UserInfo(),
                ],
              ),
            )
          ]);
        });
  }
}

//class UserInfo extends StatelessWidget {
//  User userData;
//
//  UserInfo({this.userData});
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.all(10),
//      child: Column(
//        children: <Widget>[
//          Container(
//            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
//            alignment: Alignment.topLeft,
//            child: Text(
//              "User Information",
//              style: TextStyle(
//                color: Colors.black87,
//                fontWeight: FontWeight.w500,
//                fontSize: 16,
//              ),
//              textAlign: TextAlign.left,
//            ),
//          ),
//          Card(
//            child: Container(
//              alignment: Alignment.topLeft,
//              padding: EdgeInsets.all(15),
//              child: Column(
//                children: <Widget>[
//                  Column(
//                    children: <Widget>[
//                      ...ListTile.divideTiles(
//                        color: Colors.grey,
//                        tiles: [
////                          ListTile(
////                            contentPadding: EdgeInsets.symmetric(
////                                horizontal: 12, vertical: 4),
////                            leading: Icon(Icons.my_location),
////                            title: Text("Location"),
////                            subtitle: Text("Kathmandu"),
////                            trailing:Icon(Icons.edit),
////                          ),
////---------------------------------------------------------
//                          ListTile(
//                            leading: Icon(Icons.email),
//                            title: Text("Email"),
//                            subtitle:
//                                Text(userData != null ? userData.email : ""),
//                          ),
//
////                          ListTile(
////                            leading: Icon(Icons.perm_identity),
////                            title: Text("Name"),
////                            subtitle: Text(userData!=null ? userData.name :""),
////                            trailing:Icon(Icons.edit),
////
////                          ),
//                          ProfileListTile(
//                              iconWidget: Icon(Icons.perm_identity),
//                              subTitleText: this.userData == null
//                                  ? ""
//                                  : this.userData.name,
//                              titleText: 'Name',
//                              userData: this.userData),
//
////                          ListTile(
////                            leading: Icon(Icons.phone),
////                            title: Text("Phone"),
////                            subtitle: Text(userData!=null ? userData.phone :""),
////                            //trailing:IconBU Icon(Icons.edit),
////
////
////                            trailing:Icon(Icons.edit),
////                          ),
//                          ProfileListTile(
//                              iconWidget: Icon(Icons.phone),
//                              subTitleText: this.userData == null
//                                  ? ""
//                                  : this.userData.phone,
//                              titleText: 'Phone',
//                              userData: this.userData),
//
//                          ProfileListTile(
//                              iconWidget: Icon(Icons.home),
//                              subTitleText: this.userData == null
//                                  ? ""
//                                  : this.userData.address,
//                              titleText: 'Address',
//                              userData: this.userData),
////                          ListTile(
////                            leading: Icon(Icons.person),
////                            title:  TextFormField(
////                              initialValue: 'Email',
////                              decoration: textInputDecoration(labelText: "Product Name"),
////                              validator: (val) => val.isEmpty ? 'Please enter Product Name' : null,
////                              //onChanged: (val) => setState(() => ),
////                            ),
////                            subtitle: Text(
////                                "This is a about me link and you can khow about me in this section."),
////                            trailing:Icon(Icons.edit),
////                          ),
//                        ],
//                      ),
//                    ],
//                  )
//                ],
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}

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
      padding: EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
//          Container(
//            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
//            alignment: Alignment.topLeft,
//            child: Text(
//              "User Information",
//              style: TextStyle(
//                color: Colors.black87,
//                fontWeight: FontWeight.w500,
//                fontSize: 16,
//              ),
//              textAlign: TextAlign.left,
//            ),
//          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.white,
                        tiles: [
//                          ListTile(
//                            contentPadding: EdgeInsets.symmetric(
//                                horizontal: 12, vertical: 4),
//                            leading: Icon(Icons.my_location),
//                            title: Text("Location"),
//                            subtitle: Text("Kathmandu"),
//                            trailing:Icon(Icons.edit),
//                          ),
//--------------------------------------------------------
                          ListTile(
                            leading: Icon(Icons.perm_identity),
                            title: Text(
                              "Profile Settings",
                              //style:  TextStyle(color: Color(0xff053e57), fontSize: 16, fontWeight: FontWeight.w700),
                              style: h4,
                              textAlign: TextAlign.left,
                            ),
                            // title: Text("Email"),
                            //subtitle:Text(userData != null ? userData.email : ""),
                            // trailing:Icon(Icons.edit),
                            trailing: new IconButton(
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
                            ),
                          ),

                          buildRow("Name", userData != null ? userData.name : ""),
                          buildRow("Phone", userData != null ? userData.phone : ""),
                          buildRow("Email", userData != null ? userData.email : ""),
                          buildRow("Address", userData != null ? userData.address : ""),

//                          ProfileListTile(
//                              iconWidget: Icon(Icons.perm_identity),
//                              subTitleText: this.userData == null
//                                  ? ""
//                                  : this.userData.name,
//                              titleText: 'Name',
//                              userData: this.userData),
//
//                          ListTile(
//                            leading: Icon(Icons.phone),
//                            title: Text("Phone"),
//                            subtitle: Text(userData!=null ? userData.phone :""),
//                            //trailing:IconBU Icon(Icons.edit),
//
//
//                            trailing:Icon(Icons.edit),
//                          ),
//                          ProfileListTile(
//                              iconWidget: Icon(Icons.phone),
//                              subTitleText: this.userData == null
//                                  ? ""
//                                  : this.userData.phone,
//                              titleText: 'Phone',
//                              userData: this.userData),

//                          ProfileListTile(
//                              iconWidget: Icon(Icons.home),
//                              subTitleText: this.userData == null
//                                  ? ""
//                                  : this.userData.address,
//                              titleText: 'Address',
//                              userData: this.userData),
//                          ListTile(
//                            leading: Icon(Icons.person),
//                            title:  TextFormField(
//                              initialValue: 'Email',
//                              decoration: textInputDecoration(labelText: "Product Name"),
//                              validator: (val) => val.isEmpty ? 'Please enter Product Name' : null,
//                              //onChanged: (val) => setState(() => ),
//                            ),
//                            subtitle: Text(
//                                "This is a about me link and you can khow about me in this section."),
//                            trailing:Icon(Icons.edit),
//                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.white,
                        tiles: [
//                          ListTile(
//                            contentPadding: EdgeInsets.symmetric(
//                                horizontal: 12, vertical: 4),
//                            leading: Icon(Icons.my_location),
//                            title: Text("Location"),
//                            subtitle: Text("Kathmandu"),
//                            trailing:Icon(Icons.edit),
//                          ),
//--------------------------------------------------------
                          ListTile(
                            leading: Icon(Icons.adjust),
                            title: Text(
                              "Other Settings",
                              //style:  TextStyle(color: Color(0xff053e57), fontSize: 16, fontWeight: FontWeight.w700),
                              style: h4,
                              textAlign: TextAlign.left,
                            ),
                            // title: Text("Email"),
                            //subtitle:Text(userData != null ? userData.email : ""),
                            // trailing:Icon(Icons.edit),
                          ),

                          showLink("My Orders",  (){
                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrderTab()));
                          }),
                          showLink("Sign Out",  (){
                            AuthService().signOut().then((value) => showSnackBar(context, "Signed out"));
                          }),
//                          showLink("Sign Out",  Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: OrderTab()))),

                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader({Key key, @required this.coverImage, @required this.avatar, @required this.title, this.subtitle, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
//        Ink(
//          height: 200,
//          decoration: BoxDecoration(
//            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
//          ),
//        ),
//        Ink(
//          height: 200,
//          decoration: BoxDecoration(
//            color: Colors.black38,
//          ),
//        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 50,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar({Key key, @required this.image, this.borderColor = Colors.grey, this.backgroundColor, this.radius = 13, this.borderWidth = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null ? backgroundColor : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image,
        ),
      ),
    );
  }
}

class ProfileListTile extends StatefulWidget {
  bool isUpdate;
  final Widget iconWidget;
  String titleText;
  String subTitleText;
  User userData;

  ProfileListTile({
    Key key,
    @required this.iconWidget,
    @required this.titleText,
    @required this.subTitleText,
    //this.isUpdate =false,
    this.userData,
  }) : super(key: key);

  @override
  _ProfileListTileState createState() => _ProfileListTileState();
}

class _ProfileListTileState extends State<ProfileListTile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.isUpdate == true) {
      return Form(
        key: _formKey,
        child: ListTile(
            //leading: Icon(Icons.person),
            leading: widget.iconWidget,
            title: TextFormField(
              initialValue: this.widget.subTitleText,
              decoration: textInputDecoration(labelText: this.widget.titleText),
              validator: (val) => val.isEmpty ? 'Please enter Product Name' : null,
              onChanged: (val) => setState(() => widget.subTitleText = val),
            ),
//      subtitle: Text(
//          "This is a about me link and you can khow about me in this section."),
            trailing: MaterialButton(
              color: primaryColor,
              shape: CircleBorder(),
              //elevation: 0,
              child: Icon(Icons.save),
              onPressed: () {
                print("-------------IsUpdate=True------------------");
                print(widget.userData.phone);
                if (_formKey.currentState.validate()) {
                  if (widget.userData != null) {
                    //Get User Id
                    this.widget.titleText.toLowerCase() == 'name' ? (widget.userData.name = widget.subTitleText) : widget.userData.name;
                    this.widget.titleText.toLowerCase() == 'phone' ? (widget.userData.phone = widget.subTitleText) : widget.userData.phone;
                    this.widget.titleText.toLowerCase() == 'email' ? (widget.userData.email = widget.subTitleText) : widget.userData.email;
                    this.widget.titleText.toLowerCase() == 'address' ? (widget.userData.address = widget.subTitleText) : widget.userData.address;

                    UserService().updateUser(widget.userData);

                    setState(() {
                      widget.isUpdate = false;
                    });

                    print(widget.isUpdate);
                  }
                }
              },
            )),
      );
    } else {
      return ListTile(
          leading: widget.iconWidget,
          title: Text(this.widget.titleText),
          subtitle: Text(this.widget.subTitleText),
          //trailing:Icon(Icons.edit),
          trailing: MaterialButton(
            color: primaryColor,
            shape: CircleBorder(),
            elevation: 0,
            child: Icon(Icons.edit),
            onPressed: () {
              print("-------------IsUpdate=False------------------");
              try {
                // print(widget.subTitleText);
                setState(() {
                  widget.isUpdate = true;
                  //print(widget._userData.name);
                });

                if (widget.userData != null) {
                  // UserProfileService(uid: "whH3upwE3lOVfGHYYzOx6T34PLt1").updateUserProfileData(widget._userData.name, widget._userData.phone, widget._userData.email, widget._userData.address);
                  //widget.product.imgUrl = null;
                  print("Old image deleted");
                } else {
                  print('Úser data null');
                  //  print(widget._userData);
                }
              } on Exception catch (e) {
                print("Error while deleting old image" + e.toString());
              }
              print(widget.isUpdate);
              //Navigator.pop(context);
            },
          ));
    }
  }
}
