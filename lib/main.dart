import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'presentation/book_list/book_list_page.dart';
import 'presentation/login/login_page.dart';
import 'presentation/signup/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('コリアンダー'),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                '',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              TextButton(
                child: Text('本一覧'),
                onPressed: () {
                  // ここでなにか
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookListPage()),
                  );
                },
              ),
              TextButton(
                child: Text('新規登録'),
                onPressed: () {
                  // ここでなにか
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
              ),
              TextButton(
                child: Text('ログイン'),
                onPressed: () {
                  // ここでなにか
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
