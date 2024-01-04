part of 'picker_bloc.dart';

@immutable
abstract class PickerState extends Equatable {
  const PickerState();
  
  @override
  List<Object> get props => [];
}

class PickerInitial extends PickerState {}

class FilePicking extends PickerState {}

class Removed extends PickerState {}

class FilePickingFailed extends PickerState {}

class FilePicked extends PickerState {
  final String fileName;
  final File file;

  const FilePicked({
    required this.file,
    required this.fileName
  });
}