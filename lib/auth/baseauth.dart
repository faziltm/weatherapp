import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
    Future<String> signIn(String email, String password);

    Future<void> signOut();

    Future<String> signUp(String email, String password);

    Future<FirebaseUser> getCurrentUser();

    Firestore getFirestore();

    FirebaseAuth getFirebaseAuth();

}

class Auth implements BaseAuth {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

      Future<String> signIn(String email, String password) async {
        AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        FirebaseUser user = result.user;
        return user.uid;
      }

    Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

   Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

    Firestore getFirestore () {
    return _firestore;
  }

  FirebaseAuth getFirebaseAuth () {
    return _firebaseAuth;
  }



}