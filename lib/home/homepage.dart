import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica2_audd/home/bloc/homerecord_bloc.dart';
import 'package:practica2_audd/login/login.dart';
import 'package:record/record.dart';
import '../auth/bloc/auth_bloc.dart';
import '../content/favmusic/favmusic.dart';
import '../content/song/songpage.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Tap to start listening",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            AvatarGlow(
              glowColor: Colors.deepPurpleAccent,
              endRadius: 200.0,
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<HomerecordBloc>(context)
                      .add(HomerecordUpdateEvent());
                },
                // =>
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => SongPage())),
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      radius: 100.0,
                      child: Image.asset(
                        //icon obtained from https://www.flaticon.com/free-icons/music
                        'assets/buttonicon.png',
                        height: 200,
                      )),
                ),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavouritePage())),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     new MaterialPageRoute(
                      //         builder: (context) => new LoginPage()),
                      //     (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
