import 'package:ecommerce_app/models/feedback.dart' as fb;
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/feedback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AdminFeedback extends StatelessWidget {

  final AuthService _auth = AuthService();
  final FeedbackService _feedbackService = FeedbackService(uid: Uuid().v1().toString());

  @override
  Widget build(BuildContext context) {


    return StreamProvider<List<fb.Feedback>>.value(
      value: FeedbackService().feedbackStream,
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
              onPressed: () {},
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
            child: FeedbackList()
        ),
      ),
    );
  }
}

///////////////////////////

class FeedbackList extends StatefulWidget {
  @override
  _FeedbackListState createState() => _FeedbackListState();
}

class _FeedbackListState extends State<FeedbackList> {
  @override
  Widget build(BuildContext context) {

    final feedbacklist = Provider.of<List<fb.Feedback>>(context) ?? [];

    return ListView.builder(
      itemCount: feedbacklist.length,
      itemBuilder: (context, index) {
        return FeedbackTile(feedback: feedbacklist[index]);
      },
    );
  }
}

////////////////////////////////////
class FeedbackTile extends StatelessWidget {

  final fb.Feedback feedback;
  FeedbackTile({ this.feedback });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child:new Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.brown[feedback.message.length],
              ),
              title: Text(feedback.name),
              subtitle: Text('${feedback.message} '),

            ),
            new Text('${feedback.phone} '),
            new Text('${feedback.email } ')
          ],
        ),

      ),
    );
  }
}