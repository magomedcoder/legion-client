class WordSpeakerEntity {
  final String word;
  final double start;
  final double end;

  WordSpeakerEntity({
    required this.word,
    required this.start,
    required this.end,
  });
}

class SpeakerSpeakerEntity {
  final double start;
  final double end;
  final int spk;

  SpeakerSpeakerEntity({
    required this.start,
    required this.end,
    required this.spk,
  });
}

class BlockSpeakerEntity {
  final double start;
  final double end;
  final int spk;
  final String text;

  BlockSpeakerEntity({
    required this.start,
    required this.end,
    required this.spk,
    required this.text,
  });
}

class SttSpeakerEntity {
  final String text;
  final List<WordSpeakerEntity> words;
  final List<SpeakerSpeakerEntity> speakers;
  final List<BlockSpeakerEntity> blocks;

  SttSpeakerEntity({
    required this.text,
    required this.words,
    required this.speakers,
    required this.blocks,
  });
}
