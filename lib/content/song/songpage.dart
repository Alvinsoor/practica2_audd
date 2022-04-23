import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica2_audd/content/bloc/firebase_bloc.dart';
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
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () {
                          //add song to favourites
                          Map<String, dynamic> favourite = {
                            "artistName": "${widget.song["artistName"]}",
                            "songName": "${widget.song["songName"]}",
                            "albumCover": "${widget.song["albumCover"]}",
                            "listenLink": "${widget.song["listenLink"]}",
                          };
                          Navigator.pop(context);
                          BlocProvider.of<FirebaseBloc>(context).add(
                              FirebaseAddFavouriteMusicEvent(
                                  favourite: favourite));
                        },
                      ),
                      TextButton(
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
      body: BlocConsumer<FirebaseBloc, FirebaseState>(
        listener: (context, state) {
          print("Firebase Listener has been called");
          // TODO: implement listener
          if (state is FirebaseAddFavSongSuccess) {
            print("$state");

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Added to favourites"),
              ));
          } else if (state is FirebaseAddFavSongError) {
            print("$state");
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Could not add to favourites. Please try again."),
                backgroundColor: Colors.red,
              ));
          } else if (state is FirebaseAddFavSongExists) {
            print("$state");
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Already in favourites!"),
                backgroundColor: Colors.red,
              ));
          } else if (state is FirebaseInitial) {
            print("$state");
          } else if (state is FirebaseAddFavSongLoading) {
            //show loading snackbar
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Adding to favourites..."),
              ));
          }
        },
        builder: (context, state) {
          return Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network("${widget.song["albumCover"]}"),
                SizedBox(height: 20),
                Text("${widget.song["songName"]}",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                SizedBox(height: 5),
                Text("${widget.song["artistName"]}",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center),
                SizedBox(height: 5),
                Text(
                  "${widget.song["albumName"]}",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  "${widget.song["releaseDate"]}",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
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
          );
        },
      ),
    );
  }
}
