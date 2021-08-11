import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/backend_work/database.dart';
import 'package:notes_app/pages.dart/first_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<DataBase>(
      create: (context) => FirestoreDataBase(),
      child: MaterialApp(
        home: FrontPage(),
      ),
    );
  }
}
