// lib/screens/saved_posts_screen.dart
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';

class SavedPostsScreen extends StatelessWidget {
  final List<Post> savedPosts;

  SavedPostsScreen({required this.savedPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts'),
      ),
      body: savedPosts.isEmpty
          ? Center(child: Text('No saved posts yet.'))
          : ListView.builder(
              itemCount: savedPosts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: savedPosts[index],
                  onDelete: () {
                    // Handle post deletion if needed
                  },
                );
              },
            ),
    );
  }
}
