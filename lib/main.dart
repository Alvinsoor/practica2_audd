import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_audd/auth/bloc/auth_bloc.dart';

import 'package:practica2_audd/home/homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'content/favmusic/favmusic.dart';
import 'login/login.dart';
import '../content/song/songpage.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent())),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music App',
        home: BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is UnAuthState) {
            return LoginPage();
          } else if (state is AuthErrorState) {
            return LoginPage();
          } else if (state is SignOutSuccessState) {
            return LoginPage();
          }
          return Scaffold(
            body: Container(
              child: CircularProgressIndicator(),
            ),
          );
        }, listener: (context, state) {
          print("Listener has been called");
          if (state is AuthSuccessState) {
            print("AuthSuccessState");
          } else if (state is UnAuthState) {
            print("UnAuthState");
          } else if (state is AuthErrorState) {
            print("AuthErrorState");
          } else {
            print("Other state: $state");
          }
        }),
        theme: ThemeData.dark());
  }
}
