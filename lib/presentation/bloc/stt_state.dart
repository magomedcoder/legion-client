import 'package:legion/domain/entities/stt_speaker.dart';

class SttState {
  final bool loading;
  final SttSpeakerEntity? data;
  final String? error;

  const SttState({this.loading = false, this.data, this.error});

  SttState copyWith({bool? loading, SttSpeakerEntity? data, String? error}) =>
      SttState(
        loading: loading ?? this.loading,
        data: data ?? this.data,
        error: error ?? this.error,
      );
}
