import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback {
  String uid = Uuid().v1();
   String name;
  String phone;
  String email;
  String message;

  //Feedback({ this.name, this.phone, this.email,this.message });
  Feedback({this.name, this.phone, this.email, this.message}) ;
  Map<String, dynamic> toMap() {
    return {'uid': this.uid,'name': this.name, 'phone': this.phone, 'email': this.email, 'message': this.message};
  }

  Feedback.fromFireBaseSnapshot(Map snapshot)
      : uid = snapshot['uid'],
        name = snapshot['name'],
        phone = snapshot['phone'],
        email = snapshot['email'],
        message = snapshot['message'];
}


