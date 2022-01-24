// import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //signup user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    // required Uint8List file,
  }) async {
    String res = "Some error occurred";

    try {
      bool uniqueusername = true;
      await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get()
          .then((value) =>
              value.size == 0 ? uniqueusername = true : uniqueusername = false);
      if (uniqueusername == false) {
        print("Username already exists");
      } else if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        //add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
        });

        //2nd option
        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
