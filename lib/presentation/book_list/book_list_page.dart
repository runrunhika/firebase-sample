import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_booklist_app/domain/book.dart';
import 'package:firebase_booklist_app/presentation/add_book/add_book_page.dart';
import 'package:firebase_booklist_app/presentation/signup/signup_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'book_list_model.dart';

class BookListPage extends StatefulWidget {
  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..getKoronaListRealtime(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Consumer<BookListModel>(
          builder: (context, model, child) {
            final books = model.books;
            final listTiles = books
                .map((book) => Container(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  book.name.isEmpty
                                      ? '名無し : ' + book.createdAt.toString()
                                      : book.name +
                                          ' : ' +
                                          book.createdAt.toString(),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(.5)),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black),
                                    ),
                                    book.imageURL.isEmpty
                                        ? SizedBox()
                                        : Image.network(book.imageURL),
                                  ],
                                ),
                                onLongPress: () async {
                                  // todo: 削除
                                  await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('${book.title}を削除しますか？'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text('OK'),
                                            onPressed: () async {
                                              Navigator.of(context).pop();

                                              // TODO: 削除のAPIを叩く
                                              await deleteBook(
                                                  context, model, book);
                                            },
                                          ),
                                          ElevatedButton(
                                            child: Text('NO'),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )

                    // ListTile(
                    //   leading: book.imageURL.isEmpty
                    //       ? SizedBox()
                    //       : Image.network(book.imageURL),
                    //   title: Text(book.title),
                    //   trailing: IconButton(
                    //     icon: Icon(Icons.edit),
                    //     onPressed: () async {
                    //       // todo: 画面遷移

                    //       await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => AddBookPage(
                    //             book: book,
                    //           ),
                    //           fullscreenDialog: true,
                    //         ),
                    //       );
                    //       model.fetchBooks();
                    //     },
                    //   ),
                    //   onLongPress: () async {
                    //     // todo: 削除
                    //     await showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return AlertDialog(
                    //           title: Text('${book.title}を削除しますか？'),
                    //           actions: <Widget>[
                    //             ElevatedButton(
                    //               child: Text('OK'),
                    //               onPressed: () async {
                    //                 Navigator.of(context).pop();

                    //                 // TODO: 削除のAPIを叩く
                    //                 await deleteBook(context, model, book);
                    //               },
                    //             ),
                    //             ElevatedButton(
                    //               child: Text('NO'),
                    //               onPressed: () async {
                    //                 Navigator.of(context).pop();
                    //               },
                    //             ),
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    )
                .toList();
            return ListView(
              children: listTiles,
            );
          },
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              // todo
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );
              model.getKoronaListRealtime();
            },
          );
        }),
      ),
    );
  }

  Future deleteBook(
    BuildContext context,
    BookListModel model,
    Book book,
  ) async {
    try {
      await model.deleteBook(book);
      await model.getKoronaListRealtime();
    } catch (e) {
      await _showDialog(context, e.toString());
      print(e.toString());
    }
  }

  Future _showDialog(
    BuildContext context,
    String title,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
