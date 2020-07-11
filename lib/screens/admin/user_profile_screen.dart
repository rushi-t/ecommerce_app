import 'package:ecommerce_app/models/feedback.dart' as fb;
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/user/user_profile.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/user.dart';
import 'package:ecommerce_app/services/user.dart';
import 'package:ecommerce_app/services/feedback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserProfileAdmin extends StatelessWidget {
  final AuthService _auth = AuthService();
  final UserService _userProfile = UserService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
      value: _userProfile.usersStream,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: (){},
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('/assets/coffee_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: UserProfileList()),
      ),
    );
  }
}

///////////////////////////

class UserProfileList extends StatefulWidget {
  @override
  _UserProfileListState createState() => _UserProfileListState();
}

class _UserProfileListState extends State<UserProfileList> {
  @override
  Widget build(BuildContext context) {
    final userlist = Provider.of<List<User>>(context) ?? [];

    return ListView.builder(
      itemCount: userlist.length,
      itemBuilder: (context, index) {
        return UserProfileTile(user: userlist[index]);
      },
    );
  }
}

////////////////////////////////////
class UserProfileTile extends StatelessWidget {
  final User user;

  UserProfileTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: new Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.brown[user.address.length],
              ),
              title: Text(user.name),
              subtitle: Text('${user.address} '),
            ),
            new Text('${user.phone} '),
            new Text('${user.email} ')
          ],
        ),
      ),
    );
  }
}
