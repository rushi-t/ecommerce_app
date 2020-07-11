import 'package:ecommerce_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  UserService();

  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future<void> createUser(User user) async {
    return await userCollection.add(user.toMap());
  }

  Future<void> updateUser(User user) async {
    return await userCollection.document(user.uid).setData(user.toMap());
  }

  Future<void> deleteUser(User user) async {
    return await userCollection.document(user.uid).delete();
  }

  // Product list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((documentSnapshot) {
      return User.fromFireBaseSnapshot(documentSnapshot.data);
    }).toList();
  }

  // get brews stream
  Stream<List<User>> get usersStream {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  // get user doc stream
  Future<User> getUser(String uid) async{
    DocumentSnapshot documentSnapshot = await userCollection.document(uid).get();
    return User.fromFireBaseSnapshot(documentSnapshot.data);
  }
}
