//import 'package:ecommerce_app/models/brew.dart';
//import 'package:ecommerce_app/models/user.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//class DatabaseService {
//
//  final String uid;
//  DatabaseService({ this.uid });
//
//  // collection reference
//  final CollectionReference brewCollection = Firestore.instance.collection('users');
//
//  Future<void> updateUserData(String sugars, String name, int strength) async {
//    return await brewCollection.document(uid).setData({
//      'sugars': sugars,
//      'name': name,
//      'strength': strength,
//    });
//  }
//
//  // brew list from snapshot
//  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
//    return snapshot.documents.map((doc){
//      //print(doc.data);
//      return Brew(
//        name: doc.data['name'] ?? '',
//        strength: doc.data['email'] ?? 0,
//        sugars: doc.data['address'] ?? '0'
//      );
//    }).toList();
//  }
//
//  // user data from snapshots
//  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//    return UserData(
//      uid: uid,
//      name: snapshot.data['name'],
//      email: snapshot.data['email'],
//      address: snapshot.data['address']
//    );
//  }
//
//  // get brews stream
//  Stream<List<Brew>> get brews {
//    return brewCollection.snapshots()
//      .map(_brewListFromSnapshot);
//  }
//
//  // get user doc stream
//  Stream<UserData> get userData {
//    return brewCollection.document(uid).snapshots()
//      .map(_userDataFromSnapshot);
//  }
//
//}