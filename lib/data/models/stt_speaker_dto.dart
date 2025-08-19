import 'package:legion/domain/entities/stt_speaker.dart';

class WordSpeakerDto extends WordSpeakerEntity {
  WordSpeakerDto({
    required super.word,
    required super.start,
    required super.end,
  });

  factory WordSpeakerDto.fromJson(Map<String, dynamic> json) => WordSpeakerDto(
    word: json['word'] as String? ?? '',
    start: (json['start'] as num?)?.toDouble() ?? 0.0,
    end: (json['end'] as num?)?.toDouble() ?? 0.0,
  );
}

class SpeakerSpeakerDto extends SpeakerSpeakerEntity {
  SpeakerSpeakerDto({
    required super.start,
    required super.end,
    required super.spk,
  });

  factory SpeakerSpeakerDto.fromJson(Map<String, dynamic> json) =>
      SpeakerSpeakerDto(
        start: (json['start'] as num?)?.toDouble() ?? 0.0,
        end: (json['end'] as num?)?.toDouble() ?? 0.0,
        spk: (json['spk'] as num?)?.toInt() ?? 0,
      );
}

class BlockSpeakerDto extends BlockSpeakerEntity {
  BlockSpeakerDto({
    required super.start,
    required super.end,
    required super.spk,
    required super.text,
  });

  factory BlockSpeakerDto.fromJson(Map<String, dynamic> json) =>
      BlockSpeakerDto(
        start: (json['start'] as num?)?.toDouble() ?? 0.0,
        end: (json['end'] as num?)?.toDouble() ?? 0.0,
        spk: (json['spk'] as num?)?.toInt() ?? 0,
        text: json['text'] as String? ?? '',
      );
}

class SttSpeakerDto extends SttSpeakerEntity {
  SttSpeakerDto({
    required super.text,
    required super.words,
    required super.speakers,
    required super.blocks,
  });

  factory SttSpeakerDto.fromJson(Map<String, dynamic> json) => SttSpeakerDto(
    text: json['text'] as String? ?? '',
    words: (json['words'] as List<dynamic>? ?? [])
        .map((e) => WordSpeakerDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    speakers: (json['speakers'] as List<dynamic>? ?? [])
        .map((e) => SpeakerSpeakerDto.fromJson(e as Map<String, dynamic>))
        .toList(),
    blocks: (json['blocks'] as List<dynamic>? ?? [])
        .map((e) => BlockSpeakerDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
