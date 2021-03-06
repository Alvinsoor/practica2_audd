import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica2_audd/content/bloc/firebase_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class FavouritePage extends StatefulWidget {
  FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  late List<dynamic> _favourites;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourite songs',
          style: GoogleFonts.lato(),
        ),
      ),
      body: BlocConsumer<FirebaseBloc, FirebaseState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is FirebaseGetFavMusicSuccess) {
            _favourites = state.favourites;
          }
          if (state is FirebaseRemoveFavSongSuccess) {
            //success snackbar
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Song removed from favourites"),
                duration: Duration(seconds: 2),
              ),
            );
            BlocProvider.of<FirebaseBloc>(context)
                .add(FirebaseGetFavouriteMusicEvent());
          }
          if (state is FirebaseRemoveFavSongLoading) {
            //loading snackbar
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Removing song from favourites..."),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is FirebaseGetFavMusicSuccess) {
            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _favourites.length; i++)
                      cardGen(_favourites, i),
                  ],
                ),
              ),
            );
          } else if (state is FirebaseGetFavMusicLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FirebaseGetFavMusicIsEmpty) {
            return Center(
              child: Text("No favourite songs yet"),
            );
          } else if (state is FirebaseRemoveFavSongLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text("Ice cream machine broke"),
            );
          }
        },
      ),
    );
  }

  Card cardGen(List<dynamic> favourites, var index) {
    return Card(
      child: Stack(
        children: [
          //a sample view of an album cover which is clickable
          GestureDetector(
            onTap: () {
              //alert dialogue to confirm opening link
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Open link"),
                    content: Text(
                        "Are you sure you want to open the link to this song?"),
                    actions: [
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () {
                          //open link
                          Navigator.pop(context);
                          _launchURL('${favourites[index]['listenLink']}');
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
            child: Image.network('${favourites[index]['albumCover']}'),
          ),

          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                //alert dialogue for removing favourite
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Remove favourite"),
                      content: Text(
                          "Are you sure you want to remove this song from your favourites?"),
                      actions: [
                        TextButton(
                          child: Text("Yes"),
                          onPressed: () {
                            //remove favourite
                            Navigator.pop(context);
                            BlocProvider.of<FirebaseBloc>(context).add(
                                FirebaseRemoveFavouriteMusicEvent(
                                    index: index));
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
              icon: Icon(Icons.favorite),
              color: Colors.red,
              iconSize: 40,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(1),
                    Colors.purple.withOpacity(0.0),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      '${favourites[index]['songName']}',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: Text(
                      '${favourites[index]['artistName']}',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
