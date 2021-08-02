import 'dart:io';

import 'package:firebase_booklist_app/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'add_book_model.dart';

class AddBookPage extends StatelessWidget {
  AddBookPage({this.book});
  final Book book;

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = book != null;
    final textEditingController = TextEditingController();
    final nameEditingController = TextEditingController();

    if (isUpdate) {
      textEditingController.text = book.title;
    }

    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text(isUpdate ? '本を編集' : '本を追加'),
            ),
            body: Consumer<AddBookModel>(
              builder: (context, model, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "任意",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextField(
                            controller: nameEditingController,
                            decoration: InputDecoration(
                              filled: true,
                              focusColor: Colors.lightBlue.shade100,
                              border: OutlineInputBorder(),
                              labelText: "ニックネーム",
                            ),
                            onChanged: (text) {
                              model.name = text;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "任意",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              // TODO: カメラロール開いて写真選ぶ
                              final pickedFile = await picker.getImage(
                                  source: ImageSource.gallery);
                              model.setImage(File(pickedFile.path));
                            },
                            child: SizedBox(
                              width: 100,
                              height: 160,
                              child: model.imageFile != null
                                  ? Image.file(model.imageFile)
                                  : Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "必須",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextField(
                            maxLength: 60,
                            maxLines: 5,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              filled: true,
                              focusColor: Colors.lightBlue.shade100,
                              border: OutlineInputBorder(),
                              labelText: "掲示板に投稿したい内容を記入しよう",
                            ),
                            onChanged: (text) {
                              model.bookTitle = text;
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        child: Text(isUpdate ? '更新する' : '追加する'),
                        onPressed: () async {
                          model.startLoading();

                          if (isUpdate) {
                            await updateBook(model, context);
                          } else {
                            // firestoreに本を追加
                            await addBook(model, context);
                          }
                          model.endLoading();
                        },
                      ),
                    ],
                  ),
                  // Column(
                  //   children: <Widget>[
                  //     TextField(
                  //       controller: nameEditingController,
                  //       onChanged: (text) {
                  //         model.name = text;
                  //       },
                  //     ),
                  //     InkWell(
                  //       onTap: () async {
                  //         // TODO: カメラロール開いて写真選ぶ
                  //         final pickedFile =
                  //             await picker.getImage(source: ImageSource.camera);
                  //         model.setImage(File(pickedFile.path));
                  //       },
                  //       child: SizedBox(
                  //         width: 100,
                  //         height: 160,
                  //         child: model.imageFile != null
                  //             ? Image.file(model.imageFile)
                  //             : Container(
                  //                 color: Colors.grey,
                  //               ),
                  //       ),
                  //     ),
                  //     TextField(
                  //       controller: textEditingController,
                  //       onChanged: (text) {
                  //         model.bookTitle = text;
                  //       },
                  //     ),
                  //     ElevatedButton(
                  //       child: Text(isUpdate ? '更新する' : '追加する'),
                  //       onPressed: () async {
                  //         model.startLoading();

                  //         if (isUpdate) {
                  //           await updateBook(model, context);
                  //         } else {
                  //           // firestoreに本を追加
                  //           await addBook(model, context);
                  //         }
                  //         model.endLoading();
                  //       },
                  //     ),
                  //   ],
                  // ),
                );
              },
            ),
          ),
          Consumer<AddBookModel>(builder: (context, model, child) {
            return model.isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox();
          }),
        ],
      ),
    );
  }

  Future addBook(AddBookModel model, BuildContext context) async {
    try {
      await model.addBookToFirebase();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存しました！'),
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
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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

  Future updateBook(AddBookModel model, BuildContext context) async {
    try {
      await model.updateBook(book);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('更新しました！'),
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
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
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
}
