import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SongPage extends StatefulWidget {
  SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}

class _SongPageState extends State<SongPage> {
  var _album = "Mothership";
  var _apple =
      "https://music.apple.com/us/album/inspire-the-liars/1138328704?at=1000l33QU&i=1138329271&mt=1";
  var _spotify = "https://open.spotify.com/track/2DdluBZleLq30PlfUAqSD5";
  var _artist = "Dance Gavin Dance";
  var _cover =
      "https://i.scdn.co/image/ab67616d0000b273209ec0e7aef2871a5a4c2f49";
  var _listn = "https://lis.tn/InspireTheLiars";
  var _name = "Inspire The Liars";
  var _release = "2014-09-18";
  var _iconsize = 40.0;

  @override
  Widget build(BuildContext context) {
    //return song page
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border),
          ),
        ],
        title: Text(
          "Here you go!",
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(_cover),
            SizedBox(height: 20),
            Text(_name,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(_artist, style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text(_album, style: TextStyle(fontSize: 15)),
            SizedBox(height: 5),
            Text(_release, style: TextStyle(fontSize: 15)),
            Divider(
              height: 30,
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Colors.black26,
            ),
            Text("Open song in:",
                style: TextStyle(
                  fontSize: 13,
                )),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL(_apple);
                  },
                  icon: Icon(Icons.apple),
                ),
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL(_spotify);
                  },
                  icon: Image.asset(
                    'assets/spotify.png',
                    height: 30,
                  ),
                ),
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL(_listn);
                  },
                  icon: Icon(Icons.podcasts),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
