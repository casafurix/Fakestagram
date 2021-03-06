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

  Future<void> likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  Future<void> postComment(String postID, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentID = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postID)
            .collection('comments')
            .doc(commentID)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentID': commentID,
          'datePublished': DateTime.now(),
        });
      } else {
        print('Empty text..');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  //deleting post
  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc('postID').delete();
    } catch (err) {
      print(
        err.toString(),
      );
    }
  }

  Future<void> followUser(String uid, String followID) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followID)) {
        await _firestore.collection('users').doc(followID).update({
          "followers": FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayRemove([followID])
        });
      } else {
        await _firestore.collection('users').doc(followID).update({
          "followers": FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          "following": FieldValue.arrayUnion([followID])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
