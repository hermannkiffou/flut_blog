import 'package:flut_blog/blog.dart';
import 'package:flut_blog/homePage.dart';
import 'package:flut_blog/inscription.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.id,
        routes: {
          HomePage.id: (conext) => HomePage(),
          Inscription.id: (context) => Inscription(),
          BlogPage.id: (constex) => BlogPage(),
        },
        home: HomePage());
  }
}
