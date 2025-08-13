class ReplyDto {
  final String? text;
  final String? wavBase64;

  ReplyDto({this.text, this.wavBase64});

  factory ReplyDto.fromJson(Map<String, dynamic> json) => ReplyDto(
    text: json['text'] as String?,
    wavBase64: json['wav_base64'] as String?,
  );
}
