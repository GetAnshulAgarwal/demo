// lib/screens/liked_posts_screen.dart
import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';

class LikedPostsScreen extends StatelessWidget {
  final List<Post> likedPosts;

  LikedPostsScreen({required this.likedPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Posts'),
      ),
      body: likedPosts.isEmpty
          ? Center(child: Text('No liked posts yet.'))
          : ListView.builder(
              itemCount: likedPosts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: likedPosts[index],
                  onDelete: () {
                    // Handle post deletion if needed
                  },
                );
              },
            ),
    );
  }
}
