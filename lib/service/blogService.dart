import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlogService {
  final CollectionReference blogCollection =
      FirebaseFirestore.instance.collection('blog');

  Stream<QuerySnapshot> getBlogStream() {
    return blogCollection.snapshots();
  }

  deleteBlog(blogId) {
    var myBblog =
        FirebaseFirestore.instance.collection('blog').doc(blogId).delete();
    if (myBblog != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<User?> deleteUser(BuildContext context, String id) async {}
  
}
