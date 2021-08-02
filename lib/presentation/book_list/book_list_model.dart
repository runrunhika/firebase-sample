import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_booklist_app/domain/book.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];

  // Future fetchBooks() async {
  //   final docs = await FirebaseFirestore.instance.collection('books').get();
  //   final books = docs.docs.map((doc) => Book(doc)).toList();
  //   this.books = books;
  //   notifyListeners();
  // }

  void getKoronaListRealtime() {
    final snapshots =
        FirebaseFirestore.instance.collection('books').snapshots();
    snapshots.listen((snapshot) {
      final docs = snapshot.docs;
      final books = docs.map((doc) => Book(doc)).toList();
      books.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      this.books = books;
      notifyListeners();
    });
  }

  Future deleteBook(Book book) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(book.documentID)
        .delete();
  }
}
