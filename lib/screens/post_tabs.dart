// lib/screens/post_tabs.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';

class PostTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Posts'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Liked'),
              Tab(text: 'Saved'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PostList(isLiked: true),
            PostList(isLiked: false),
          ],
        ),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final bool isLiked;

  PostList({required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        List<Post> filteredPosts = postProvider.posts.where((post) {
          return isLiked ? post.isLiked : post.isSaved;
        }).toList();

        return ListView.builder(
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) {
            Post post = filteredPosts[index];
            return PostCard(
                post: post, onDelete: () => postProvider.deletePost(post));
          },
        );
      },
    );
  }
}
