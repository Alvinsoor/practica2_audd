part of 'firebase_bloc.dart';

abstract class FirebaseEvent extends Equatable {
  const FirebaseEvent();

  @override
  List<Object> get props => [];
}

class FirebaseGetFavouriteMusicEvent extends FirebaseEvent {}

class FirebaseRemoveFavouriteMusicEvent extends FirebaseEvent {
  final int index;

  FirebaseRemoveFavouriteMusicEvent({required this.index});
  @override
  List<Object> get props => [this.index];
}

class FirebaseAddFavouriteMusicEvent extends FirebaseEvent {
  final Map<String, dynamic> favourite;

  FirebaseAddFavouriteMusicEvent({required this.favourite});
  @override
  List<Object> get props => [this.favourite];
}
