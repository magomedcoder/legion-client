class UtteranceRequestDto {
  final String text;
  final String format;

  UtteranceRequestDto({required this.text, required this.format});

  Map<String, dynamic> toJson() => {'text': text, 'format': format};
}
