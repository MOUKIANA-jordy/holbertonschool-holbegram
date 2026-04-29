import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart'; // Assure-toi que le chemin est correct

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --------------------- LOGIN ---------------------
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Please fill all the fields';
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  // --------------------- SIGN UP ---------------------
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file, // pour l’image de profil
  }) async {
    try {
      if (email.isEmpty || password.isEmpty || username.isEmpty) {
        return 'Please fill all the fields';
      }

      // Création du compte Firebase
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        // Ici tu peux uploader l'image sur Cloudinary si file != null
        String photoUrl = ''; // placeholder pour l'image

        // Crée l'objet Users
        Users users = Users(
          uid: user.uid,
          email: email,
          username: username,
          bio: '',
          photoUrl: photoUrl,
          followers: [],
          following: [],
          posts: [],
          saved: [],
          searchKey: username[0].toUpperCase(),
        );

        // Stocke dans Firestore
        await _firestore.collection('users').doc(user.uid).set(users.toJson());

        return 'success';
      } else {
        return 'Erreur: utilisateur non trouvé';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // --------------------- GET USER DETAILS ---------------------
  Future<Users> getUserDetails() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUser.uid).get();
      return Users.fromSnap(snap);
    } else {
      throw Exception('No user logged in');
    }
  }
}
