class CommandRequestDto {
  final String text;
  final String format;

  CommandRequestDto({required this.text, required this.format});

  Map<String, dynamic> toJson() => {'text': text, 'format': format};
}
