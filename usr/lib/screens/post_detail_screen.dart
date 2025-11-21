import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';
import '../services/blog_service.dart';
import '../services/auth_service.dart';

class PostDetailScreen extends StatefulWidget {
  final BlogPost post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.isEmpty) return;

    final user = context.read<AuthService>().currentUser;
    if (user != null) {
      context.read<BlogService>().addComment(
            widget.post.id,
            user,
            _commentController.text,
          );
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final comments = context.watch<BlogService>().getCommentsForPost(widget.post.id);
    final authService = context.watch<AuthService>();
    final currentUser = authService.currentUser;
    final isAuthor = currentUser?.id == widget.post.author.id;
    final isAuthenticated = authService.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        actions: [
          if (isAuthor)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<BlogService>().deletePost(widget.post.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'By ${widget.post.author.displayName}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMd().format(widget.post.createdAt),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Text(
                    widget.post.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  Text(
                    'Comments (${comments.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  if (comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text('No comments yet. Be the first to share your thoughts!'),
                    ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(comment.author.displayName[0]),
                        ),
                        title: Text(comment.author.displayName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.content),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat.yMMMd().add_jm().format(comment.createdAt),
                              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isAuthenticated)
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: _submitComment,
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[100],
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text('Log in to leave a comment'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
