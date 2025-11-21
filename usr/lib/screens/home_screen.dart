import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/blog_service.dart';
import '../services/auth_service.dart';
import '../models/post.dart';
import 'post_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final blogService = context.watch<BlogService>();
    final isAuthenticated = authService.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CouldAI Blog'),
        actions: [
          if (isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                authService.logout();
                // No navigation needed, state change will rebuild UI
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
            )
          else
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: blogService.posts.isEmpty
          ? const Center(child: Text('No posts yet.'))
          : ListView.builder(
              itemCount: blogService.posts.length,
              itemBuilder: (context, index) {
                final post = blogService.posts[index];
                return _BlogCard(post: post);
              },
            ),
      floatingActionButton: isAuthenticated
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create-post');
              },
              tooltip: 'Create Post',
              child: const Icon(Icons.edit),
            )
          : null, // Hide FAB if not authenticated
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogPost post;

  const _BlogCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostDetailScreen(post: post),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    child: Text(post.author.displayName[0].toUpperCase()),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.author.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.yMMMd().format(post.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                post.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${post.likes}'),
                  const SizedBox(width: 16),
                  Icon(Icons.comment_outlined, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  const Text('Read more'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
