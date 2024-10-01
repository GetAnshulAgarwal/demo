// lib/services/local_storage_demo.dart
import 'package:flutter/material.dart';
import 'database_helper.dart';
import '../models/post.dart';

class LocalStorageDemo {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Insert a post into the local database
  Future<void> insertPost(Post post) async {
    await _databaseHelper.insertPost(post);
  }

  // Retrieve all posts from the local database
  Future<List<Post>> getAllPosts() async {
    return await _databaseHelper.getPosts();
  }

  // Delete a post by ID
  Future<void> deletePost(String id) async {
    await _databaseHelper.deletePost(id);
  }

  // Example method to demonstrate fetching posts
  Future<void> fetchAndPrintPosts() async {
    List<Post> posts = await getAllPosts();
    for (Post post in posts) {
      print('Title: ${post.title}, Content: ${post.content}');
    }
  }
}
