import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

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
              "Toque para escuchar",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            AvatarGlow(
              glowColor: Colors.deepPurpleAccent,
              endRadius: 200.0,
              child: GestureDetector(
                onTap: () => print("mid tapped"),
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
                    onPressed: () {
                      print("fav tapped");
                    },
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () {
                      print("logout tapped");
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
