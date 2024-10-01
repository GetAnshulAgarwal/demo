// lib/services/post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  final String apiUrl = 'https://evika.onrender.com/api/event';

  Future<List<Post>> fetchPosts(int page, String apiToken) async {
    final response = await http.get(
      Uri.parse(apiUrl + page.toString()),
      headers: {
        'Authorization':
            'Bearer $apiToken', // Include the API token in the headers
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((postData) {
        return Post(
          id: postData['id'].toString(),
          title: postData['title'],
          content: postData['content'],
          imageUrl: postData['imageUrl'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
