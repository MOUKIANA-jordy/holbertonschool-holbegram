import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please fill all the fields';
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      res = 'success';
    } on FirebaseAuthException catch (e) {
      res = e.message ?? 'Authentication failed';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return 'Please fill all the fields';
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user == null) {
        return 'Unable to create user';
      }

      final Users users = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: '',
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username.isNotEmpty
            ? username.substring(0, 1).toUpperCase()
            : '',
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(users.toJson());

      res = 'success';
    } on FirebaseAuthException catch (e) {
      res = e.message ?? 'Authentication failed';
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<Users> getUserDetails() async {
    final User currentUser = _auth.currentUser!;

    final DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return Users.fromSnap(snap);
  }
}
