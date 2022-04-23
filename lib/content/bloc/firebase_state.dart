part of 'firebase_bloc.dart';

abstract class FirebaseState extends Equatable {
  const FirebaseState();

  @override
  List<Object> get props => [];
}

class FirebaseInitial extends FirebaseState {}

class FirebaseGetFavMusicSuccess extends FirebaseState {
  final Map<String, dynamic> favourite;
  FirebaseGetFavMusicSuccess({required this.favourite});
  @override
  List<Object> get props => [this.favourite];
}

class FirebaseGetFavMusicError extends FirebaseState {}

class FirebaseAddFavSongLoading extends FirebaseState {}

class FirebaseAddFavSongSuccess extends FirebaseState {}

class FirebaseAddFavSongError extends FirebaseState {}

class FirebaseAddFavSongExists extends FirebaseState {}

class FirebaseRemoveFavSongSuccess extends FirebaseState {}

class FirebaseRemoveFavSongError extends FirebaseState {}
