import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practica2_audd/content/song/songpage.dart';
import 'package:practica2_audd/home/bloc/homerecord_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../content/favmusic/favmusic.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _songName;
  var _artistName;
  var _albumName;
  var _releaseDate;
  var _appleLink;
  var _spotifyLink;
  var _albumCover;
  var _listenLink;

  String _listenStatus = "Tap to start listening";
  bool _effect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<HomerecordBloc, HomerecordState>(
            listener: (context, state) {
          // TODO: implement listener
          print("Listener has been called");
          if (state is HomerecordSuccessState) {
            print("$state");
            _songName = state.songName;
            _artistName = state.artistName;
            _albumName = state.albumName;
            _releaseDate = state.releaseDate;
            _appleLink = state.appleLink;
            _spotifyLink = state.spotifyLink;
            _albumCover = state.albumCover;
            _listenLink = state.listenLink;

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SongPage(song: {
                "songName": _songName,
                "artistName": _artistName,
                "albumName": _albumName,
                "releaseDate": _releaseDate,
                "appleLink": _appleLink,
                "spotifyLink": _spotifyLink,
                "albumCover": _albumCover,
                "listenLink": _listenLink,
              }),
            ));
            _effect = false;
            _listenStatus = "Tap to start listening";
          } else if (state is HomerecordFailureState) {
            print("$state");
            _effect = false;
            _listenStatus = "Tap to start listening";
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text("Could not detect song. Please try again."),
                backgroundColor: Colors.red,
              ));
          } else if (state is HomerecordFinishedState) {
            _effect = true;
            _listenStatus = "Detecting song...";
            print("$state");
          } else if (state is HomerecordListeningState) {
            print("$state");
            _effect = true;
            _listenStatus = "Listening...";
          } else if (state is HomerecordInitial) {
            print("$state");
          } else if (state is HomerecordMissingValuesState) {
            print("$state");
            _effect = false;
            _listenStatus = "Tap to start listening";
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(
                    "Song was missing either Apple music or Spotify link. Please try again."),
                backgroundColor: Colors.red,
              ));
          }
        }, builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _listenStatus,
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
                animate: _effect,
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
          );
        }),
      ),
    );
  }
}
