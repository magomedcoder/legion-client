import 'package:equatable/equatable.dart';

enum MessageAuthor { user, assistant, system }

class Message extends Equatable {
  final String id;
  final MessageAuthor author;
  final String? text;
  final String? wavBase64;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.author,
    this.text,
    this.wavBase64,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, author, text, wavBase64, createdAt];
}
