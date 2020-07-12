import 'dart:async';

import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/services/database.dart';
import 'package:ecommerce_app/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final AuthService _instance = AuthService._privateConstructor();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User userInstance;

  AuthService._();

  AuthService._privateConstructor();

  factory AuthService() {
    return _instance;
  }

  bool isLoggedIn() {
    return userInstance != null;
  }

  Future<FirebaseUser> getFireBaseUser() async {
    return _auth.currentUser();
  }

  // auth change user stream
  Stream<User> get user {
//    if (kDebugMode == true) {
//      print("Using dummy user");
//      this.userInstance = User("M5xzvS3OrVXROwIIsQQfSVCZQ5w2");
//      return Stream.value(this.userInstance);
//    }
//    else
     {
      _auth.onAuthStateChanged.transform(StreamTransformer<FirebaseUser, User>.fromHandlers(handleData: (firebaseUser, user) async {
        if (firebaseUser == null) return null;
        this.userInstance = await UserService().getUser(firebaseUser.uid);
        user.add(this.userInstance);
//      print("## User= " + user.toString());
      }));
    }
  }

  // sign in Anonymously
  Future<User> signInAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      if (result.user == null) return null;

      FirebaseUser firebaseUser = result.user;
      this.userInstance = User(firebaseUser.uid);
      await UserService().updateUser(userInstance);
      return userInstance;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user == null) return null;

      FirebaseUser user = result.user;
      this.userInstance = await UserService().getUser(user.uid);
      return userInstance;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future<User> registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user == null) return null;

      FirebaseUser firebaseUser = result.user;
      this.userInstance = User(firebaseUser.uid, email: firebaseUser.email);
      await UserService().updateUser(userInstance);
      return userInstance;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      this.userInstance = null;
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
