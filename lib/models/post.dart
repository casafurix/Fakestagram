import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String description;
  final String uid;
  final String postID;
  final String username;
  final datePublished;
  final String postURL;
  final String profImage;
  final likes;

  const Post({
    required this.description,
    required this.uid,
    required this.postID,
    required this.username,
    required this.datePublished,
    required this.postURL,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "postID": postID,
        "username": username,
        "datePublished": datePublished,
        "postURL": postURL,
        "profImage": profImage,
        "likes": likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      postID: snapshot['postID'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
      postURL: snapshot['postURL'],
      profImage: snapshot['profImage'],
      likes: snapshot['likes'],
    );
  }
}
