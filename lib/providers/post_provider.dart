import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import HTTP package
import '../models/post.dart';
import '../services/database_helper.dart'; // Import the database helper

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  String? _errorMessage;
  bool _isLoading = false; // New loading state
  final String apiToken; // Store the API token

  PostProvider({required this.apiToken}); // Accept API token via constructor

  List<Post> get posts => _posts;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading; // Expose loading state

  // Fetch posts from the API and local database
  Future<void> fetchPosts() async {
    _errorMessage = null;
    _isLoading = true; // Set loading to true
    notifyListeners(); // Notify listeners about loading state

    try {
      // Clear current posts to force refresh
      _posts.clear();

      // Fetch posts from the API
      await _fetchPostsFromApi();

      // If no posts are found in the API response, fallback to local database
      if (_posts.isEmpty) {
        _posts = await DatabaseHelper().getPosts();

        if (_posts.isEmpty) {
          // If no posts are found, generate mock data and insert it
          await _insertMockData(); // Insert mock data
          _posts = await DatabaseHelper().getPosts(); // Fetch again
        }
      }

      // Log the fetched posts for debugging
      print("Fetched posts: $_posts");
    } catch (error) {
      _errorMessage = 'Error fetching posts: ${error.toString()}';
      print("Error: $_errorMessage");
    } finally {
      _isLoading = false; // Set loading to false
      notifyListeners(); // Notify listeners after data fetch
    }
  }

  Future<void> _fetchPostsFromApi() async {
    final response = await http.get(
      Uri.parse('https://evika.onrender.com/api/event'),
      headers: {
        'Authorization': 'Bearer $apiToken',
        'Content-Type': 'application/json',
      },
    );

    // Log raw response for debugging
    print('Raw API Response: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(
          'Decoded API Response: $responseData'); // Add this line for better debugging

      // Check for expected data structure
      if (responseData.containsKey('data') &&
          responseData['data'].containsKey('events')) {
        List<dynamic> events = responseData['data']['events'];

        // Log number of events
        print('Number of events fetched: ${events.length}');

        // Handle empty events
        if (events.isEmpty) {
          print('No events found for this page.');
          _posts.clear(); // Clear posts if no events
        } else {
          // Map the event data to Post instances
          _posts = events.map((eventJson) => Post.fromJson(eventJson)).toList();
          print('Fetched posts: $_posts'); // Log the fetched posts
        }
      } else {
        throw Exception('Unexpected data structure: Missing "events" key');
      }
    } else {
      throw Exception(
          'Failed to load posts from API. Status code: ${response.statusCode}');
    }
  }

  // Insert mock posts into the database
  Future<void> _insertMockData() async {
    List<Post> mockPosts = [
      Post(
        id: '1',
        title: 'Political News',
        content: 'Economic challenges in India',
        imageUrl: 'assets/image1.png', // Use local asset image
      ),
      Post(
        id: '2',
        title: 'Spreading of the Crop Disease',
        content: 'Spreading of the Crop Disease',
        imageUrl: 'assets/banner3.jpg', // Use local asset image
      ),
      Post(
        id: '3',
        title: '',
        content: 'Traditional Event',
        imageUrl: 'assets/image3.jpg', // Use local asset image
      ),
      Post(
        id: '4',
        title: '',
        content: 'Capital Growth',
        imageUrl: 'assets/image4.webp', // Use local asset image
      ),
      Post(
        id: '5',
        title: '',
        content: 'Economy',
        imageUrl: 'assets/image5.jpeg', // Use local asset image
      ),
    ];

    for (var post in mockPosts) {
      await DatabaseHelper().insertPost(post);
    }
    print("Inserted mock posts.");
  }

  // Delete a post (locally)
  void deletePost(Post post) {
    final index = _posts.indexOf(post);
    if (index != -1) {
      _posts.removeAt(index);
      DatabaseHelper().deletePost(post.id); // Delete from local database
      notifyListeners();
    } else {
      print('Error: Post not found');
    }
  }

  // Toggle like status of a post
  void toggleLike(Post post) {
    final index = _posts.indexOf(post);
    if (index != -1) {
      _posts[index].isLiked = !_posts[index].isLiked;
      notifyListeners();
    } else {
      print('Error: Post not found');
    }
  }

  // Toggle save status of a post
  void toggleSave(Post post) {
    final index = _posts.indexOf(post);
    if (index != -1) {
      _posts[index].isSaved = !_posts[index].isSaved;
      notifyListeners();
    } else {
      print('Error: Post not found');
    }
  }
}
