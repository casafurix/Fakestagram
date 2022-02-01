import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some error occurred.";
    try {
      String photoURL =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postID = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postID: postID,
          datePublished: DateTime.now(),
          postURL: photoURL,
          profImage: profImage,
          likes: []);

      _firestore.collection('posts').doc(postID).set(post.toJson());
      res = "Success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
