import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/loginbg.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, .9)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      "assets/icon.webp",
                      height: 120,
                    ),
                    SizedBox(height: 150),
                    Text(
                      "Utilice una red social:",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        //BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black54,
    );
  }
}
