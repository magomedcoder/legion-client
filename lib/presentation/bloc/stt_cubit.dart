import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legion/domain/usecases/upload_stt_speaker_usecase.dart';
import 'package:legion/presentation/bloc/stt_state.dart';

class SttCubit extends Cubit<SttState> {
  final UploadSttSpeakerUseCase uploadSttSpeakerUseCase;

  SttCubit(this.uploadSttSpeakerUseCase) : super(const SttState());

  Future<void> uploadAndParse(File file) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final result = await uploadSttSpeakerUseCase(
        file,
        diarize: true,
        returnSrt: false,
      );
      emit(SttState(data: result));
    } catch (e) {
      emit(SttState(error: e.toString()));
    }
  }

  void reset() => emit(const SttState());
}
