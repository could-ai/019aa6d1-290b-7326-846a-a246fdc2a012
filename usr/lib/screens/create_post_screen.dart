import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/blog_service.dart';
import '../services/auth_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _publishPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final user = context.read<AuthService>().currentUser;
      if (user != null) {
        await context.read<BlogService>().addPost(
              user,
              _titleController.text,
              _contentController.text,
            );
        if (mounted) {
          Navigator.pop(context);
        }
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _publishPost,
            child: const Text(
              'Publish',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const Divider(),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Start writing your story...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                minLines: 10,
                validator: (value) => value!.isEmpty ? 'Content cannot be empty' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
