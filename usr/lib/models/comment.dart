import 'user.dart';

class Comment {
  final String id;
  final String postId;
  final User author;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.author,
    required this.content,
    required this.createdAt,
  });
}
