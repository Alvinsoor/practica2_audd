import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouritePage extends StatefulWidget {
  FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favourite songs',
          style: GoogleFonts.lato(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 5; i++) cardGen(context),
            ],
          ),
        ),
      ),
    );
  }

  Card cardGen(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          //a sample view of an album cover which is clickable
          GestureDetector(
            onTap: () {
              print("Card tapped");
            },
            child: Image.network(
                'https://i.scdn.co/image/ab67616d0000b273209ec0e7aef2871a5a4c2f49'),
          ),

          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                print('clicked');
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
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Inspire The Liars',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Dance Gavin Dance',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
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
