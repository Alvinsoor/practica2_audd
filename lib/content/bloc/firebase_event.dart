part of 'firebase_bloc.dart';

abstract class FirebaseEvent extends Equatable {
  const FirebaseEvent();

  @override
  List<Object> get props => [];
}

class FirebaseGetFavouriteMusicEvent extends FirebaseEvent {}

class FirebaseRemoveFavouriteMusicEvent extends FirebaseEvent {
  final Map<String, dynamic> favourite;

  FirebaseRemoveFavouriteMusicEvent({required this.favourite});
  @override
  List<Object> get props => [this.favourite];
}

class FirebaseAddFavouriteMusicEvent extends FirebaseEvent {
  final Map<String, dynamic> favourite;

  FirebaseAddFavouriteMusicEvent({required this.favourite});
  @override
  List<Object> get props => [this.favourite];
}
