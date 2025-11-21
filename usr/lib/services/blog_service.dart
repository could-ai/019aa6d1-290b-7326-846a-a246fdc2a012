import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/user.dart';

class BlogService extends ChangeNotifier {
  final List<BlogPost> _posts = [];
  final Map<String, List<Comment>> _comments = {};

  List<BlogPost> get posts => List.unmodifiable(_posts);

  BlogService() {
    _seedData();
  }

  void _seedData() {
    final user1 = User(id: 'u1', email: 'alice@example.com', displayName: 'Alice');
    final user2 = User(id: 'u2', email: 'bob@example.com', displayName: 'Bob');

    _posts.addAll([
      BlogPost(
        id: 'p1',
        author: user1,
        title: 'The Future of Flutter',
        content: 'Flutter is evolving rapidly. With Impeller and Wasm support, the performance is getting better every day. This post explores the new rendering engine...',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        likes: 42,
      ),
      BlogPost(
        id: 'p2',
        author: user2,
        title: 'Mobile App Architecture',
        content: 'Choosing the right architecture is crucial. MVVM, Clean Architecture, or simple Provider patterns? Let\'s discuss the pros and cons.',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 15,
      ),
    ]);

    _comments['p1'] = [
      Comment(
        id: 'c1',
        postId: 'p1',
        author: user2,
        content: 'Great article! Impeller is a game changer.',
        createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      ),
    ];
  }

  List<Comment> getCommentsForPost(String postId) {
    return _comments[postId] ?? [];
  }

  Future<void> addPost(User author, String title, String content) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newPost = BlogPost(
      id: const Uuid().v4(),
      author: author,
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  Future<void> addComment(String postId, User author, String content) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newComment = Comment(
      id: const Uuid().v4(),
      postId: postId,
      author: author,
      content: content,
      createdAt: DateTime.now(),
    );
    
    if (!_comments.containsKey(postId)) {
      _comments[postId] = [];
    }
    _comments[postId]!.add(newComment);
    notifyListeners();
  }
  
  Future<void> deletePost(String postId) async {
     await Future.delayed(const Duration(milliseconds: 300));
     _posts.removeWhere((p) => p.id == postId);
     notifyListeners();
  }
}
