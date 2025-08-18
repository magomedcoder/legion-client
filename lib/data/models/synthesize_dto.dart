class SynthesizeRequestDto {
  final String text;

  SynthesizeRequestDto({required this.text});

  Map<String, dynamic> toJson() => {'text': text};
}

class SynthesizeReplyDto {
  final String wavBase64;

  SynthesizeReplyDto({required this.wavBase64});

  factory SynthesizeReplyDto.fromJson(Map<String, dynamic> json) =>
      SynthesizeReplyDto(wavBase64: json['wav_base64'] as String);
}
