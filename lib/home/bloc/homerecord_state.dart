part of 'homerecord_bloc.dart';

abstract class HomerecordState extends Equatable {
  const HomerecordState();

  @override
  List<Object> get props => [];
}

class HomerecordInitial extends HomerecordState {}

class HomerecordListeningState extends HomerecordState {}

class HomerecordFinishedState extends HomerecordState {}

class HomerecordSuccessState extends HomerecordState {
  String songName;

  String artistName;

  String albumName;

  String releaseDate;

  String appleLink;

  String spotifyLink;

  String albumCover;

  String listenLink;

  HomerecordSuccessState({
    required this.songName,
    required this.artistName,
    required this.albumName,
    required this.releaseDate,
    required this.appleLink,
    required this.spotifyLink,
    required this.albumCover,
    required this.listenLink,
  });
}

class HomerecordFailureState extends HomerecordState {}
