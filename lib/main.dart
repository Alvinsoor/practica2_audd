import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_audd/auth/bloc/auth_bloc.dart';
import 'package:practica2_audd/content/bloc/firebase_bloc.dart';
import 'package:practica2_audd/home/bloc/homerecord_bloc.dart';

import 'package:practica2_audd/home/homepage.dart';

import 'login/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent())),
      BlocProvider(create: (context) => HomerecordBloc()),
      BlocProvider(create: (context) => FirebaseBloc()),
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
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }, listener: (context, state) {
          print("Listener has been called");
          if (state is AuthSuccessState) {
            print("$state");
          } else if (state is UnAuthState) {
            print("$state");
          } else if (state is AuthErrorState) {
            print("$state");
          } else if (state is SignOutSuccessState) {
            print("$state");
          }
        }),
        theme: ThemeData.dark());
  }
}
