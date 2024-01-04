part of 'picker_bloc.dart';

abstract class PickerEvent extends Equatable {
  const PickerEvent();

  @override
  List<Object> get props => [];
}

class PickFile extends PickerEvent {}

class RemoveFile extends PickerEvent {}