import 'package:ecommerce_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {

  final String uid;
  UserProfileService({ this.uid });

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future<void> updateUserProfileData(String name, String phone, String email, String address) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    });
  }

  // brew list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      //print(doc.data);
      return User(
        name: doc.data['name'] ?? '',
        phone: doc.data['phone'] ?? '',
        email: doc.data['email'] ?? '',
          address: doc.data['address'] ?? '',
      );
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
        phone: snapshot.data['phone'],
        email: snapshot.data['email'],
      address: snapshot.data['address']
    );
  }

  // get brews stream
  Stream<List<User>> get users {
    return userCollection.snapshots()
      .map(_userListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userProfileData {
    return userCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

}