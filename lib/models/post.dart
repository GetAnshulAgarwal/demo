class Post {
  final String id; // Corresponds to _id in the API response
  final String title; // Title of the event
  final String content; // Description of the event
  final String imageUrl; // URL of the event image
  bool isLiked; // To track if the post is liked
  bool isSaved; // To track if the post is saved

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.isLiked = false,
    this.isSaved = false,
  });

  // Add this method for better logging
  @override
  String toString() {
    return 'Post{id: $id, title: $title, content: $content, imageUrl: $imageUrl}';
  }

  // Factory constructor to create a Post instance from a JSON object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'].toString(), // Use the _id field from the API response
      title: json['title'] ?? 'No Title', // Title from API or default value
      content: json['description'] ??
          'No Content', // Use the description for content
      imageUrl: json['images'].isNotEmpty
          ? json['images'][0]
          : '', // Get the first image URL or empty
      isLiked: json['likedUsers']?.contains(json['user']['_id']) ??
          false, // Check if the current user liked this post
      isSaved: false, // Default value for saved state
    );
  }
}
