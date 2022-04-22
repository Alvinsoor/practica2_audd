part of 'homerecord_bloc.dart';

abstract class HomerecordState extends Equatable {
  const HomerecordState();

  @override
  List<Object> get props => [];
}

class HomerecordInitial extends HomerecordState {}

class HomerecordListeningState extends HomerecordState {}

class HomerecordSuccessState extends HomerecordState {}

class HomerecordFailureState extends HomerecordState {}
