import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';

part 'firebase_event.dart';
part 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(FirebaseInitial()) {
    on<FirebaseAddFavouriteMusicEvent>(addFavSong);
  }

  Future<void> addFavSong(FirebaseAddFavouriteMusicEvent event,
      Emitter<FirebaseState> emitter) async {
    emit(FirebaseAddFavSongLoading());
    try {
      emit(FirebaseInitial());
      final userCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        print("Could not retrieve collection");
        return;
      }
      List<dynamic> favourites = collection['user-favourites'];
      print("Favourites: $favourites");
      for (var i in favourites) {
        if (i['songName'] == event.favourite['songName'] &&
            i['artistName'] == event.favourite['artistName']) {
          print("Song already exists");
          emit(FirebaseAddFavSongExists());
          return;
        }
      }

      favourites.add(event.favourite);
      await userCollection.update({'user-favourites': favourites});
      emit(FirebaseAddFavSongSuccess());
    } catch (e) {
      print("Error: $e");
      emit(FirebaseAddFavSongError());
    }
  }
}
