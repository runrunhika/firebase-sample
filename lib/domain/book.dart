import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book(DocumentSnapshot doc) {
    documentID = doc.id;
    title = doc['title'];
    imageURL = doc['imageURL'];
    name = doc['name'];

    final Timestamp timestamp = doc['createdAt'];
    this.createdAt = timestamp.toDate();
  }

  String documentID;
  String title;
  String name;
  String imageURL;
  DateTime createdAt;
}
