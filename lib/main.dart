import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practica2_audd/favmusic/favmusic.dart';
import 'package:practica2_audd/home/homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'login/login.dart';
import 'song/songpage.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music App', home: HomePage(), theme: ThemeData.dark());
  }
}
