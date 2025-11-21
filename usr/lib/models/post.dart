import 'user.dart';

class BlogPost {
  final String id;
  final User author;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final int likes;

  BlogPost({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.likes = 0,
  });
}
