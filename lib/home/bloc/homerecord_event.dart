part of 'homerecord_bloc.dart';

abstract class HomerecordEvent extends Equatable {
  const HomerecordEvent();

  @override
  List<Object> get props => [];
}

class HomerecordUpdateEvent extends HomerecordEvent {}
