import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';

part 'firebase_event.dart';
part 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(FirebaseInitial()) {
    on<FirebaseAddFavouriteMusicEvent>(addFavSong);
    on<FirebaseRemoveFavouriteMusicEvent>(rmFavSong);
    on<FirebaseGetFavouriteMusicEvent>(getFavouriteList);
  }

  Future<void> addFavSong(FirebaseAddFavouriteMusicEvent event,
      Emitter<FirebaseState> emitter) async {
    emit(FirebaseAddFavSongLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        print("Could not retrieve collection");
        return null;
      }
      List<dynamic> favourites = collection['user-favourites'];
      print("Favourites LMAO: $favourites");
      //print("Favourites song #1: ${favourites[0]['songName']}");
      if (favourites.isEmpty) {
        print("Favourites is empty");
        favourites.add(event.favourite);
        await userCollection.update({'user-favourites': favourites});
        emit(FirebaseAddFavSongSuccess());
      } else {
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
      }
    } catch (e) {
      print("Error: $e");
      emit(FirebaseAddFavSongError());
    }
  }

  Future<void> rmFavSong(FirebaseRemoveFavouriteMusicEvent event,
      Emitter<FirebaseState> emitter) async {
    emit(FirebaseRemoveFavSongLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        print("Could not retrieve collection");
        return null;
      }
      List<dynamic> favourites = collection['user-favourites'];
      //print("Favourites: $favourites");
      // var count = 0;
      // for (var i in favourites) {
      //   if (i['songName'] == event.favourite['songName'] &&
      //       i['artistName'] == event.favourite['artistName']) {
      //     favourites.removeAt(count);
      //   }
      //   count++;
      // }
      favourites.removeAt(event.index);

      await userCollection.update({'user-favourites': favourites});
      emit(FirebaseRemoveFavSongSuccess());
    } catch (e) {
      print("Error: $e");
      emit(FirebaseRemoveFavSongError());
    }
  }

  Future<void> getFavouriteList(event, emit) async {
    emit(FirebaseGetFavMusicLoading());
    try {
      DocumentReference<Map<String, dynamic>> userCollection =
          getUserCollection();

      Map<String, dynamic>? collection = (await userCollection.get()).data();

      if (collection == null) {
        print("Could not retrieve collection");
        return null;
      }
      List<dynamic> favourites = collection['user-favourites'];
      print("Favourites HOLLA: $favourites");
      if (favourites.isEmpty) {
        emit(FirebaseGetFavMusicIsEmpty());
      } else {
        print("Favourites song #1: ${favourites[0]['songName']}");
        emit(FirebaseGetFavMusicSuccess(favourites: favourites));
      }
    } catch (e) {
      print("Error: $e");
      emit(FirebaseGetFavMusicError());
    }
  }

  DocumentReference<Map<String, dynamic>> getUserCollection() {
    final userCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    return userCollection;
  }
}
