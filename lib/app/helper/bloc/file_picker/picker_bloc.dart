import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

part 'picker_event.dart';
part 'picker_state.dart';

class PickerBloc extends Bloc<PickerEvent, PickerState> {
  PickerBloc() : super(PickerInitial()) {
    on<InitializeWithFile>(_onInitializeWithFile);
    on<PickFile>(_onPickFile);
    on<RemoveFile>(_onRemoveFile);
  }

  void _onInitializeWithFile(InitializeWithFile event, Emitter emit) {
    emit(
      FilePreSelected(
        fileName: event.filePath,
      ),
    );
  }

  void _onRemoveFile(RemoveFile event, Emitter emit) {
    emit(Removed());
  }

  void _onPickFile(PickFile event, Emitter emit) async {
    emit(FilePicking());

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        String name = result.files.single.name;
        emit(
          FilePicked(
            file: file,
            fileName: name,
          ),
        );
      } else {
        emit(FilePickingFailed());
      }
    } catch (e) {
      emit(FilePickingFailed());
    }
  }
}
