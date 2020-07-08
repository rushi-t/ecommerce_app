import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._privateConstructor();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User userInstance;

  AuthService._();
  AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  Future<FirebaseUser> getFireBaseUser() async{
   return _auth.currentUser();
  }

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    this.userInstance = null;
    if(user != null) {
      this.userInstance = User(uid: user.uid);
    }
    print("_userFromFirebaseUser= " + (this.userInstance != null ? this.userInstance.toString() : "null"));
    return this.userInstance;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
//      try {
//        await user.sendEmailVerification();
//      } catch (e) {
//        print("An error occured while trying to send email        verification");
//        print(e.message);
//      }
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
