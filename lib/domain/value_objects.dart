enum ReplyFormat { none, saytxt, saywav, saytxtSaywav }

extension ReplyFormatExt on ReplyFormat {
  String get apiValue => switch (this) {
    ReplyFormat.none => 'none',
    ReplyFormat.saytxt => 'saytxt',
    ReplyFormat.saywav => 'saywav',
    ReplyFormat.saytxtSaywav => 'saytxt,saywav',
  };
}
