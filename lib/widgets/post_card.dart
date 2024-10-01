import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function onDelete; // Callback for delete functionality

  PostCard({required this.post, required this.onDelete});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _commentController = TextEditingController();
  List<String> comments = []; // Store comments locally

  // Toggles the like status
  void _toggleLike() {
    setState(() {
      widget.post.isLiked = !widget.post.isLiked;
    });
  }

  // Toggles the saved status
  void _toggleSave() {
    setState(() {
      widget.post.isSaved = !widget.post.isSaved;
    });
  }

  // Placeholder for share functionality
  void _sharePost() {
    print('Post shared: ${widget.post.title}');
  }

  // Handle comment submission
  void _submitComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        comments.add(_commentController.text);
        _commentController.clear(); // Clear the input field after submission
      });
    }
  }

  // Show comment popup
  void _showCommentPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comments for "${widget.post.title}"'),
          content: Container(
            height: 400, // Adjusted height for better space
            width: 350,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(
                              comments[index][0]
                                  .toUpperCase(), // Display first letter as avatar
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(comments[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: 16), // Edit icon
                                onPressed: () {
                                  _editComment(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    size: 16, color: Colors.red), // Delete icon
                                onPressed: () {
                                  _deleteComment(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Input field for new comments
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Add a comment...',
                    border: OutlineInputBorder(),
                    filled: true, // Fill the background
                    fillColor:
                        Colors.grey[200], // Light background for input field
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _submitComment();
                    Navigator.of(context)
                        .pop(); // Close dialog after submission
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Edit comment functionality
  void _editComment(int index) {
    _commentController.text =
        comments[index]; // Set the text of the comment to the controller
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Comment'),
          content: TextField(
            controller: _commentController,
            decoration: InputDecoration(
              labelText: 'Edit your comment...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_commentController.text.isNotEmpty) {
                  setState(() {
                    comments[index] =
                        _commentController.text; // Update the comment
                    _commentController.clear(); // Clear the input field
                  });
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Delete comment functionality
  void _deleteComment(int index) {
    setState(() {
      comments.removeAt(index); // Remove the comment from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.post.id.toString()), // Use a unique key for each post
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        widget.onDelete(); // Call the delete function passed as a parameter
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.post.title} deleted')),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
            vertical: 4, horizontal: 8), // Reduced margins for compactness
        elevation: 3, // Reduced elevation for a flatter look
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo icon at the top
            Row(
              children: [
                Image.asset(
                  'assets/flutter.png', // Add your logo path here
                  width: 30, // Reduced size
                  height: 30, // Reduced size
                ),
                SizedBox(width: 4), // Reduced spacing
                Expanded(
                  child: Text(
                    widget.post.title.isNotEmpty
                        ? widget.post.title
                        : 'No Title',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold), // Reduced font size
                  ),
                ),
              ],
            ),

            // Add post image
            widget.post.imageUrl.startsWith('http')
                ? Image.network(
                    widget.post.imageUrl,
                    fit: BoxFit.cover,
                    height: 150, // Fixed height for compactness
                    width: double.infinity, // Make it responsive
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/image1.png', // Placeholder image
                        fit: BoxFit.cover,
                        height: 150,
                      );
                    },
                  )
                : Image.asset(
                    widget.post.imageUrl,
                    fit: BoxFit.cover,
                    height: 150,
                    width: double.infinity,
                  ),

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 4.0, vertical: 4.0), // Reduced padding
              child: Text(
                widget.post.content.isNotEmpty
                    ? widget.post.content
                    : 'No Content',
                style: TextStyle(fontSize: 14), // Reduced font size
              ),
            ),

            // Interaction Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Like Button
                IconButton(
                  icon: Icon(
                    widget.post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.isLiked ? Colors.red : Colors.grey,
                    size: 18, // Reduced size
                  ),
                  onPressed: _toggleLike,
                ),

                // Save Button
                IconButton(
                  icon: Icon(
                    widget.post.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: widget.post.isSaved ? Colors.blue : Colors.grey,
                    size: 18, // Reduced size
                  ),
                  onPressed: _toggleSave,
                ),

                // Share Button
                IconButton(
                  icon: Icon(Icons.share, size: 18), // Reduced size
                  onPressed: _sharePost,
                ),

                // Comment Button
                IconButton(
                  icon: Icon(Icons.comment, size: 18), // Reduced size
                  onPressed: _showCommentPopup, // Open comment dialog
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
