import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SongPage extends StatefulWidget {
  final song;
  SongPage({Key? key, this.song}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

void _launchURL(_url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}

class _SongPageState extends State<SongPage> {
  var _iconsize = 40.0;

  @override
  Widget build(BuildContext context) {
    //return song page
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //show favourite confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Favourite"),
                    content: Text(
                        "Are you sure you want to add this song to your favourites?"),
                    actions: [
                      FlatButton(
                        child: Text("Yes"),
                        onPressed: () {
                          //add song to favourites
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text("No"),
                        onPressed: () {
                          //dismiss dialog
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
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
            Image.network("${widget.song["albumCover"]}"),
            SizedBox(height: 20),
            Text("${widget.song["songName"]}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("${widget.song["artistName"]}",
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text("${widget.song["albumName"]}", style: TextStyle(fontSize: 15)),
            SizedBox(height: 5),
            Text("${widget.song["releaseDate"]}",
                style: TextStyle(fontSize: 15)),
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
                    _launchURL("${widget.song["appleLink"]}");
                  },
                  icon: Icon(Icons.apple),
                ),
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL("${widget.song["spotifyLink"]}");
                  },
                  icon: Image.asset(
                    'assets/spotify.png',
                    height: 30,
                  ),
                ),
                IconButton(
                  iconSize: _iconsize,
                  onPressed: () {
                    _launchURL("${widget.song["listenLink"]}");
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
